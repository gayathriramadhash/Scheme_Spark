from fastapi import APIRouter
from pydantic import BaseModel
from database import get_db_connection
from difflib import SequenceMatcher
import re


router = APIRouter(
    prefix="/chatbot",
    tags=["Chatbot"]
)


class ChatRequest(BaseModel):
    message: str


# =========================================================
# TEXT NORMALIZATION
# =========================================================

def normalize_text(text):
    text = text.lower().strip()

    # Remove punctuation
    text = re.sub(r"[^\w\s]", " ", text)

    # Remove extra spaces
    text = re.sub(r"\s+", " ", text)

    return text


# =========================================================
# CHECK SIMILARITY BETWEEN TWO TEXTS
# =========================================================

def similarity(text1, text2):

    return SequenceMatcher(
        None,
        normalize_text(text1),
        normalize_text(text2)
    ).ratio()


# =========================================================
# FIND SCHEME FROM USER MESSAGE
# =========================================================

def find_scheme(message, schemes):

    normalized_message = normalize_text(message)

    best_scheme = None
    best_score = 0

    for scheme in schemes:

        scheme_name = normalize_text(scheme["scheme_name"])

        # ---------------------------------------------
        # Exact scheme name
        # ---------------------------------------------

        if scheme_name in normalized_message:

            return scheme

        # ---------------------------------------------
        # Compare individual words
        # ---------------------------------------------

        scheme_words = scheme_name.split()

        message_words = normalized_message.split()

        matched_words = 0

        for scheme_word in scheme_words:

            if len(scheme_word) <= 2:
                continue

            for message_word in message_words:

                word_score = similarity(
                    scheme_word,
                    message_word
                )

                if word_score >= 0.75:
                    matched_words += 1
                    break

        if scheme_words:

            word_score = matched_words / len(
                [word for word in scheme_words if len(word) > 2]
            ) if any(
                len(word) > 2 for word in scheme_words
            ) else 0

        else:
            word_score = 0

        # ---------------------------------------------
        # Compare scheme name with message
        # ---------------------------------------------

        overall_score = similarity(
            scheme_name,
            normalized_message
        )

        # ---------------------------------------------
        # Combined score
        # ---------------------------------------------

        final_score = max(
            word_score,
            overall_score
        )

        if final_score > best_score:

            best_score = final_score
            best_scheme = scheme

    # -------------------------------------------------
    # Minimum confidence
    # -------------------------------------------------

    if best_score >= 0.45:

        return best_scheme

    return None


# =========================================================
# CHECK QUESTION TYPE
# =========================================================

def contains_any(message, words):

    message = normalize_text(message)

    for word in words:

        if normalize_text(word) in message:
            return True

    return False


# =========================================================
# MAIN CHATBOT
# =========================================================

@router.post("/")
def chatbot(request: ChatRequest):

    message = request.message.strip()

    if not message:

        return {
            "reply": "Please enter a government scheme related question."
        }

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:

        # =================================================
        # GET ALL SCHEMES
        # =================================================

        cursor.execute(
            """
            SELECT
                s.scheme_id,
                s.scheme_name,
                s.description,
                s.benefits,
                s.eligibility,
                s.documents,
                s.official_link,
                c.category_name
            FROM schemes s
            LEFT JOIN categories c
                ON s.category_id = c.category_id
            ORDER BY s.scheme_name
            """
        )

        all_schemes = cursor.fetchall()


        # =================================================
        # FIND SCHEME
        # =================================================

        scheme = find_scheme(
            message,
            all_schemes
        )


        # =================================================
        # QUESTION KEYWORDS
        # =================================================

        benefit_words = [

            # English
            "benefit",
            "benefits",
            "advantage",
            "advantages",
            "use",
            "uses",
            "what do i get",

            # Tanglish
            "benefit enna",
            "benefits enna",
            "enna benefit",
            "enna benefits",
            "enna use",
            "use enna",
            "payan enna",
            "enna payan",
            "nanmai enna",
            "enna nanmai",

            # Tamil
            "பயன்",
            "பயன்கள்",
            "நன்மை",
            "நன்மைகள்",
            "என்ன பயன்",
            "என்ன பயன்கள்",
            "என்ன நன்மை",
            "என்ன நன்மைகள்"
        ]


        eligibility_words = [

            # English
            "eligibility",
            "eligible",
            "who can apply",
            "who is eligible",
            "qualification",
            "qualify",

            # Tanglish
            "yaar eligible",
            "yar eligible",
            "yaaruku eligible",
            "yaruku eligible",
            "yaar apply panna mudiyum",
            "yar apply panna mudiyum",
            "yaar apply pannalam",
            "yar apply pannalam",
            "yaar thaguthi",
            "yar thaguthi",
            "thaguthi enna",
            "eligible ah",

            # Tamil
            "தகுதி",
            "தகுதியானவர்கள்",
            "யார் தகுதியானவர்கள்",
            "யார் விண்ணப்பிக்கலாம்",
            "யார் விண்ணப்பிக்க முடியும்",
            "விண்ணப்பிக்கலாம்"
        ]


        document_words = [

            # English
            "document",
            "documents",
            "required document",
            "required documents",
            "certificate",
            "certificates",
            "proof",

            # Tanglish
            "documents enna",
            "document enna",
            "enna documents",
            "enna document",
            "entha documents",
            "thevaiyana documents",
            "thevaiyana document",
            "certificate enna",
            "enna certificate",
            "proof enna",

            # Tamil
            "ஆவணம்",
            "ஆவணங்கள்",
            "தேவையான ஆவணங்கள்",
            "என்ன ஆவணங்கள்",
            "சான்றிதழ்",
            "சான்றிதழ்கள்",
            "தேவையான சான்றிதழ்கள்"
        ]


        category_words = [

            # English
            "category",
            "which category",

            # Tanglish
            "entha category",
            "category enna",
            "which category",
            "intha scheme entha category",

            # Tamil
            "வகை",
            "எந்த வகை",
            "எந்த பிரிவு",
            "பிரிவு என்ன"
        ]


        link_words = [

            # English
            "link",
            "official link",
            "official website",
            "website",
            "apply",
            "application",

            # Tanglish
            "link kudu",
            "link venum",
            "official link kudu",
            "website kudu",
            "epdi apply",
            "eppadi apply",
            "apply epdi",
            "apply eppadi",
            "apply panna",
            "apply panrathu epdi",

            # Tamil
            "இணையதளம்",
            "அதிகாரப்பூர்வ இணையதளம்",
            "இணைப்பு",
            "விண்ணப்பிக்க",
            "எப்படி விண்ணப்பிப்பது",
            "விண்ணப்பிப்பது எப்படி"
        ]


        # =================================================
        # IF SCHEME FOUND
        # =================================================

        if scheme:

            # ---------------------------------------------
            # BENEFITS
            # ---------------------------------------------

            if contains_any(message, benefit_words):

                return {
                    "reply": (
                        f"Scheme: {scheme['scheme_name']}\n\n"
                        f"Benefits:\n{scheme['benefits']}"
                    )
                }


            # ---------------------------------------------
            # ELIGIBILITY
            # ---------------------------------------------

            if contains_any(message, eligibility_words):

                return {
                    "reply": (
                        f"Scheme: {scheme['scheme_name']}\n\n"
                        f"Eligibility:\n{scheme['eligibility']}"
                    )
                }


            # ---------------------------------------------
            # DOCUMENTS
            # ---------------------------------------------

            if contains_any(message, document_words):

                return {
                    "reply": (
                        f"Scheme: {scheme['scheme_name']}\n\n"
                        f"Required Documents:\n{scheme['documents']}"
                    )
                }


            # ---------------------------------------------
            # CATEGORY
            # ---------------------------------------------

            if contains_any(message, category_words):

                return {
                    "reply": (
                        f"Scheme: {scheme['scheme_name']}\n\n"
                        f"Category: {scheme['category_name']}"
                    )
                }


            # ---------------------------------------------
            # OFFICIAL LINK / APPLY
            # ---------------------------------------------

            if contains_any(message, link_words):

                return {
                    "reply": (
                        f"Scheme: {scheme['scheme_name']}\n\n"
                        f"Official Link:\n{scheme['official_link']}"
                    )
                }


            # ---------------------------------------------
            # GENERAL SCHEME INFORMATION
            # ---------------------------------------------

            return {
                "reply": (
                    f"Scheme: {scheme['scheme_name']}\n\n"
                    f"Category: {scheme['category_name']}\n\n"
                    f"Description:\n{scheme['description']}\n\n"
                    f"Benefits:\n{scheme['benefits']}\n\n"
                    f"Eligibility:\n{scheme['eligibility']}\n\n"
                    f"Documents:\n{scheme['documents']}\n\n"
                    f"Official Link:\n{scheme['official_link']}"
                )
            }


        # =================================================
        # CATEGORY SEARCH
        # =================================================

        cursor.execute(
            """
            SELECT
                category_id,
                category_name
            FROM categories
            ORDER BY category_name
            """
        )

        categories = cursor.fetchall()

        best_category = None
        best_category_score = 0

        for category in categories:

            category_name = category["category_name"]

            normalized_category = normalize_text(
                category_name
            )

            normalized_message = normalize_text(
                message
            )

            if normalized_category in normalized_message:

                best_category = category
                break

            score = similarity(
                normalized_category,
                normalized_message
            )

            if score > best_category_score:

                best_category_score = score
                best_category = category


        if best_category and best_category_score >= 0.55:

            cursor.execute(
                """
                SELECT scheme_name
                FROM schemes
                WHERE category_id = %s
                ORDER BY scheme_name
                """,
                (best_category["category_id"],)
            )

            schemes = cursor.fetchall()

            if schemes:

                scheme_list = "\n".join(
                    [
                        f"- {item['scheme_name']}"
                        for item in schemes
                    ]
                )

                return {
                    "reply": (
                        f"Available schemes under "
                        f"{best_category['category_name']}:\n\n"
                        f"{scheme_list}"
                    )
                }

            return {
                "reply": (
                    f"No schemes are currently available "
                    f"under {best_category['category_name']}."
                )
            }


        # =================================================
        # UNKNOWN QUESTION
        # =================================================

        return {
            "reply": (
                "Sorry, I could not find a matching government "
                "scheme in Scheme Spark.\n\n"
                "You can ask me about scheme benefits, "
                "eligibility, documents, category, or official link."
            )
        }


    finally:

        cursor.close()
        conn.close()