from fastapi import APIRouter
from services.recommendation import get_recommended_schemes

router = APIRouter(
    prefix="/recommendation",
    tags=["Recommendation"]
)


@router.get("/{email}")
def recommend(email: str):
    return get_recommended_schemes(email)