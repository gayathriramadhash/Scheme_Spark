from fastapi import APIRouter
from database import get_db_connection

router = APIRouter(
    prefix="/schemes",
    tags=["Schemes"]
)


@router.get("/")
def get_schemes():
    connection = get_db_connection()

    if connection is None:
        return {"message": "Database connection failed"}

    cursor = connection.cursor(dictionary=True)

    cursor.execute("SELECT * FROM schemes")

    schemes = cursor.fetchall()

    cursor.close()
    connection.close()

    return {
        "message": "Schemes fetched successfully",
        "schemes": schemes
    }
@router.get("/category/{category_id}")
def get_schemes_by_category(category_id: int):

    connection = get_db_connection()

    if connection is None:
        return {"message": "Database connection failed"}

    cursor = connection.cursor(dictionary=True)

    query = """
        SELECT *
        FROM schemes
        WHERE category_id = %s
    """

    cursor.execute(query, (category_id,))

    schemes = cursor.fetchall()

    cursor.close()
    connection.close()

    return {
        "message": "Category schemes fetched successfully",
        "category_id": category_id,
        "schemes": schemes
    }