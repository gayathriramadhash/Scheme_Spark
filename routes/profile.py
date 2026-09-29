from fastapi import APIRouter
from pydantic import BaseModel
from datetime import date
from typing import Optional
from database import get_db_connection


router = APIRouter(
    prefix="/profile",
    tags=["Profile"]
)


# =====================================================
# BASIC PROFILE
# =====================================================

class ProfileData(BaseModel):
    email: str
    name: str
    dob: date
    age: int
    gender: str
    marital_status: str
    education_level: str
    currently_studying: str
    course: str
    occupation: str
    annual_family_income: float
    state: str
    district: str


# =====================================================
# SAVE BASIC PROFILE
# =====================================================

@router.post("/setup")
def setup_profile(profile: ProfileData):

    connection = get_db_connection()

    if connection is None:
        return {
            "message": "Database connection failed"
        }

    cursor = connection.cursor()

    try:

        query = """
            INSERT INTO profile (
                email,
                name,
                dob,
                age,
                gender,
                marital_status,
                education_level,
                currently_studying,
                course,
                occupation,
                annual_family_income,
                state,
                district
            )
            VALUES (
                %s, %s, %s, %s, %s, %s, %s,
                %s, %s, %s, %s, %s, %s
            )
        """

        cursor.execute(
            query,
            (
                profile.email,
                profile.name,
                profile.dob,
                profile.age,
                profile.gender,
                profile.marital_status,
                profile.education_level,
                profile.currently_studying,
                profile.course,
                profile.occupation,
                profile.annual_family_income,
                profile.state,
                profile.district
            )
        )

        connection.commit()

        return {
            "message": "Profile setup successful",
            "profile": profile
        }

    except Exception as e:

        connection.rollback()

        return {
            "message": "Error while saving profile",
            "error": str(e)
        }

    finally:

        cursor.close()
        connection.close()


# =====================================================
# GET BASIC PROFILE
# =====================================================

@router.get("/{email}")
def get_profile(email: str):

    connection = get_db_connection()

    if connection is None:
        return {
            "message": "Database connection failed"
        }

    cursor = connection.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                email,
                name,
                dob,
                age,
                gender,
                marital_status,
                education_level,
                currently_studying,
                course,
                occupation,
                annual_family_income,
                state,
                district
            FROM profile
            WHERE email = %s
            """,
            (email,)
        )

        profile = cursor.fetchone()

        if profile is None:
            return {
                "message": "Profile not found"
            }

        return {
            "message": "Profile fetched successfully",
            "profile": profile
        }

    except Exception as e:

        return {
            "message": "Error while fetching profile",
            "error": str(e)
        }

    finally:

        cursor.close()
        connection.close()


# =====================================================
# ADDITIONAL PROFILE
# =====================================================

class AdditionalProfileData(BaseModel):

    email: str
    selected_category_id: int

    # Education
    school_type: Optional[str] = None
    school_medium: Optional[str] = None
    school_class: Optional[str] = None
    studied_govt_school_6_12: Optional[str] = None
    currently_in_higher_education: Optional[str] = None
    college_type: Optional[str] = None
    hostel_required: Optional[str] = None
    academic_marks: Optional[float] = None
    learning_support_required: Optional[str] = None

    # Women Welfare
    is_family_head: Optional[str] = None
    has_ration_card: Optional[str] = None
    ration_card_type: Optional[str] = None
    is_shg_member: Optional[str] = None
    shg_size: Optional[int] = None
    shg_regular_savings: Optional[str] = None
    is_orphan: Optional[str] = None
    is_widow: Optional[str] = None
    is_unmarried_woman: Optional[str] = None
    is_deserted_woman: Optional[str] = None
    years_deserted: Optional[int] = None
    legal_separation_status: Optional[str] = None
    has_girl_child: Optional[str] = None
    girl_child_count: Optional[int] = None
    has_male_child: Optional[str] = None
    sterilization_status: Optional[str] = None
    is_pregnant: Optional[str] = None
    pregnancy_registered: Optional[str] = None
    delivery_count: Optional[int] = None
    is_lactating: Optional[str] = None
    is_inter_caste_marriage: Optional[str] = None
    marriage_assistance_required: Optional[str] = None

    # Employment
    employment_registered: Optional[str] = None
    employment_registration_years: Optional[int] = None
    currently_employed: Optional[str] = None
    job_seeking: Optional[str] = None
    technical_qualification: Optional[str] = None
    business_interest: Optional[str] = None
    proposed_business: Optional[str] = None

    # Agriculture
    is_farmer: Optional[str] = None
    has_agricultural_land: Optional[str] = None
    land_ownership: Optional[str] = None
    land_area: Optional[float] = None
    cultivation_status: Optional[str] = None
    crop_type: Optional[str] = None
    farmer_identity_card: Optional[str] = None
    farmer_group_member: Optional[str] = None
    needs_farm_machinery: Optional[str] = None
    agriculture_degree: Optional[str] = None
    agri_business: Optional[str] = None
    landless_agricultural_labourer: Optional[str] = None

    # Health
    cmchis_eligible: Optional[str] = None
    health_condition: Optional[str] = None
    needs_home_healthcare: Optional[str] = None
    medical_screening_required: Optional[str] = None
    accident_case: Optional[str] = None

    # Housing
    rural_urban: Optional[str] = None
    owns_house: Optional[str] = None
    hut_house: Optional[str] = None
    house_condition: Optional[str] = None
    house_damage: Optional[str] = None
    has_house_site: Optional[str] = None
    owns_land: Optional[str] = None
    land_patta: Optional[str] = None
    deprivation_criteria_met: Optional[str] = None
    housing_board_registered: Optional[str] = None
    unorganised_worker_registered: Optional[str] = None

    # Social Security
    is_destitute: Optional[str] = None
    is_bpl: Optional[str] = None

    # Differently Abled
    is_differently_abled: Optional[str] = None
    disability_type: Optional[str] = None
    disability_percentage: Optional[int] = None
    has_disability_certificate: Optional[str] = None

    # BC / MBC / Minorities
    community: Optional[str] = None
    community_certificate: Optional[str] = None
    minority_status: Optional[str] = None
    minority_certificate: Optional[str] = None

    # Children
    child_age: Optional[int] = None
    child_gender: Optional[str] = None
    child_school_status: Optional[str] = None
    is_child_in_need_of_care: Optional[str] = None
    is_abandoned_or_surrendered_child: Optional[str] = None
    parental_support_available: Optional[str] = None


# =====================================================
# SAVE ADDITIONAL PROFILE
# =====================================================

@router.post("/additional")
def save_additional_profile(
    data: AdditionalProfileData
):

    connection = get_db_connection()

    if connection is None:
        return {
            "message": "Database connection failed"
        }

    cursor = connection.cursor()

    try:

        # Convert Pydantic model into dictionary
        data_dict = data.model_dump()

        # Remove fields that were not provided
        data_dict = {
            key: value
            for key, value in data_dict.items()
            if value is not None
        }

        # Check whether this user already has
        # an additional profile
        cursor.execute(
            """
            SELECT additional_id
            FROM profile_additional
            WHERE email = %s
            """,
            (data.email,)
        )

        existing = cursor.fetchone()

        # =================================================
        # UPDATE EXISTING RECORD
        # =================================================

        if existing:

            update_fields = []
            update_values = []

            for field, value in data_dict.items():

                if field == "email":
                    continue

                update_fields.append(
                    f"{field} = %s"
                )

                update_values.append(value)

            update_values.append(data.email)

            query = f"""
                UPDATE profile_additional
                SET {", ".join(update_fields)}
                WHERE email = %s
            """

            cursor.execute(
                query,
                tuple(update_values)
            )

        # =================================================
        # INSERT NEW RECORD
        # =================================================

        else:

            columns = list(data_dict.keys())
            values = list(data_dict.values())

            column_names = ", ".join(columns)

            placeholders = ", ".join(
                ["%s"] * len(values)
            )

            query = f"""
                INSERT INTO profile_additional
                ({column_names})
                VALUES ({placeholders})
            """

            cursor.execute(
                query,
                tuple(values)
            )

        connection.commit()

        return {
            "message":
                "Additional profile saved successfully",
            "email": data.email,
            "selected_category_id":
                data.selected_category_id
        }

    except Exception as e:

        connection.rollback()

        return {
            "message":
                "Error while saving additional profile",
            "error": str(e)
        }

    finally:

        cursor.close()
        connection.close()