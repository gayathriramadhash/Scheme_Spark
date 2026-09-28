from fastapi import APIRouter
from pydantic import BaseModel
from database import get_db_connection

router = APIRouter(prefix="/auth", tags=["Authentication"])


class RegisterUser(BaseModel):
    email: str
    password: str


@router.post("/register")
def register(user: RegisterUser):

    connection = get_db_connection()
    cursor = connection.cursor()

    query = """
        INSERT INTO users (email, password)
        VALUES (%s, %s)
    """

    cursor.execute(query, (user.email, user.password))
    connection.commit()

    cursor.close()
    connection.close()

    return {
        "message": "Registration successful",
        "email": user.email
    }
class LoginUser(BaseModel):
    email: str
    password: str


@router.post("/login")
def login(user: LoginUser):

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    query = """
        SELECT user_id, email
        FROM users
        WHERE email = %s AND password = %s
    """

    cursor.execute(query, (user.email, user.password))
    result = cursor.fetchone()

    cursor.close()
    connection.close()

    if result:
        return {
            "message": "Login successful",
            "user_id": result["user_id"],
            "email": result["email"]
        }

    return {
        "message": "Invalid email or password"
    }