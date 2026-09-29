from fastapi import FastAPI

from routes import auth, profile, schemes, recommendation, saved, chatbot


app = FastAPI()


app.include_router(auth.router)

app.include_router(profile.router)

app.include_router(schemes.router)

app.include_router(recommendation.router)

app.include_router(saved.router)

app.include_router(chatbot.router)


@app.get("/")
def home():

    return {"message": "Scheme Spark Backend is Working!"}