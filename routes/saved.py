from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from database import get_db_connection

router = APIRouter(
    prefix="/saved",
    tags=["Saved Schemes"]
)

class SavedSchemeRequest(BaseModel):
    email: str
    scheme_id: int


# Save a scheme
@router.post("/")
def save_scheme(data: SavedSchemeRequest):

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            """
            SELECT saved_id
            FROM saved_schemes
            WHERE email = %s AND scheme_id = %s
            """,
            (data.email, data.scheme_id)
        )

        existing = cursor.fetchone()

        if existing:
            return {
                "message": "Scheme already saved"
            }

        cursor.execute(
            """
            INSERT INTO saved_schemes (email, scheme_id)
            VALUES (%s, %s)
            """,
            (data.email, data.scheme_id)
        )

        conn.commit()

        return {
            "message": "Scheme saved successfully"
        }

    finally:
        cursor.close()
        conn.close()


# Get saved schemes
@router.get("/{email}")
def get_saved_schemes(email: str):

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
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
                ss.saved_at
            FROM saved_schemes ss
            JOIN schemes s
                ON ss.scheme_id = s.scheme_id
            WHERE ss.email = %s
            ORDER BY ss.saved_at DESC
            """,
            (email,)
        )

        schemes = cursor.fetchall()

        return schemes

    finally:
        cursor.close()
        conn.close()


# Remove saved scheme
@router.delete("/")
def remove_saved_scheme(data: SavedSchemeRequest):

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            """
            DELETE FROM saved_schemes
            WHERE email = %s AND scheme_id = %s
            """,
            (data.email, data.scheme_id)
        )

        conn.commit()

        return {
            "message": "Scheme removed from saved"
        }

    finally:
        cursor.close()
        conn.close()