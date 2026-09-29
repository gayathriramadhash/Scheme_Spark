from database import get_db_connection


def get_recommended_schemes(email):

    connection = get_db_connection()

    if connection is None:
        return {
            "message": "Database connection failed",
            "recommendations": []
        }

    cursor = connection.cursor(dictionary=True)

    try:

        # =====================================================
        # 1. GET BASIC PROFILE
        # =====================================================

        cursor.execute(
            """
            SELECT *
            FROM profile
            WHERE email = %s
            """,
            (email,)
        )

        profile = cursor.fetchone()

        if profile is None:
            return {
                "message": "Profile not found",
                "email": email,
                "recommendations": []
            }


        # =====================================================
        # 2. GET ADDITIONAL PROFILE
        # =====================================================

        cursor.execute(
            """
            SELECT *
            FROM profile_additional
            WHERE email = %s
            """,
            (email,)
        )

        additional_profile = cursor.fetchone()


        # =====================================================
        # 3. COMBINE BASIC + ADDITIONAL PROFILE
        # =====================================================

        complete_profile = {}

        # Add basic profile fields
        complete_profile.update(profile)

        # Add additional profile fields
        if additional_profile is not None:
            complete_profile.update(additional_profile)


        # =====================================================
        # 4. GET ALL SCHEMES
        # =====================================================

        cursor.execute(
            """
            SELECT *
            FROM schemes
            ORDER BY scheme_id
            """
        )

        schemes = cursor.fetchall()

        recommendations = []


        # =====================================================
        # 5. CHECK EVERY SCHEME
        # =====================================================

        for scheme in schemes:

            scheme_id = scheme["scheme_id"]


            # =================================================
            # GET RULES FOR THIS SCHEME
            # =================================================

            cursor.execute(
                """
                SELECT field_name, operator, value
                FROM scheme_rules
                WHERE scheme_id = %s
                ORDER BY rule_id
                """,
                (scheme_id,)
            )

            rules = cursor.fetchall()


            # If no rules are available,
            # skip this scheme for now
            if not rules:
                continue


            eligible = True
            matched_rules = []


            # =================================================
            # CHECK ALL RULES
            # =================================================

            for rule in rules:

                field_name = rule["field_name"]
                operator = rule["operator"]
                required_value = rule["value"]


                # Get value from combined profile
                profile_value = complete_profile.get(field_name)


                # If user does not have this information,
                # the rule cannot be satisfied
                if profile_value is None:

                    eligible = False
                    break


                profile_value = str(profile_value).strip()
                required_value = str(required_value).strip()


                # =================================================
                # EQUAL
                # =================================================

                if operator == "=":

                    if profile_value.lower() != required_value.lower():

                        eligible = False
                        break


                # =================================================
                # GREATER THAN OR EQUAL
                # =================================================

                elif operator == ">=":

                    try:

                        if float(profile_value) < float(required_value):

                            eligible = False
                            break

                    except (ValueError, TypeError):

                        eligible = False
                        break


                # =================================================
                # LESS THAN OR EQUAL
                # =================================================

                elif operator == "<=":

                    try:

                        if float(profile_value) > float(required_value):

                            eligible = False
                            break

                    except (ValueError, TypeError):

                        eligible = False
                        break


                # =================================================
                # GREATER THAN
                # =================================================

                elif operator == ">":

                    try:

                        if float(profile_value) <= float(required_value):

                            eligible = False
                            break

                    except (ValueError, TypeError):

                        eligible = False
                        break


                # =================================================
                # LESS THAN
                # =================================================

                elif operator == "<":

                    try:

                        if float(profile_value) >= float(required_value):

                            eligible = False
                            break

                    except (ValueError, TypeError):

                        eligible = False
                        break


                # =================================================
                # UNKNOWN OPERATOR
                # =================================================

                else:

                    eligible = False
                    break


                matched_rules.append(
                    f"{field_name} {operator} {required_value}"
                )


            # =================================================
            # ADD ELIGIBLE SCHEME
            # =================================================

            if eligible:

                recommendations.append({

                    "scheme_id": scheme["scheme_id"],

                    "scheme_name": scheme["scheme_name"],

                    "description": scheme["description"],

                    "benefits": scheme["benefits"],

                    "eligibility": scheme["eligibility"],

                    "documents": scheme["documents"],

                    "official_link": scheme["official_link"],

                    "reason": "Eligible based on profile rules"

                })


        # =====================================================
        # FINAL RESPONSE
        # =====================================================

        return {

            "message": "Recommendations fetched successfully",

            "email": email,

            "recommendations": recommendations

        }


    except Exception as e:

        return {

            "message": "Error while fetching recommendations",

            "error": str(e),

            "recommendations": []

        }


    finally:

        cursor.close()
        connection.close()