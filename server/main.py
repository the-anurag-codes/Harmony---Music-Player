from fastapi import FastAPI
from models.base import Base
from db import engine
from routes import auth
from routes import song

app = FastAPI()    

app.include_router(auth.router, prefix='/auth')
app.include_router(song.router, prefix='/song')

Base.metadata.create_all(bind=engine)





