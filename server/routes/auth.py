
import uuid
import bcrypt
from fastapi import Depends, HTTPException, APIRouter, Header
import db
from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.create_user import CreateUser
from pydantic_schemas.login_user import LoginUser
from sqlalchemy.orm import Session
import jwt

router = APIRouter()

@router.post('/signup', status_code=201)
def signup_user(user: CreateUser, db: Session=Depends(db.get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    
    if user_db:
        raise HTTPException(400,"User with the same email already exists!" )
    
    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt(16))
    user_db = User(id=str(uuid.uuid4()), email=user.email, password=hashed_pw, name=user.name)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    
    return user_db

@router.post('/login')
def login_user(user: LoginUser, db: Session=(Depends(db.get_db))):
    user_db = db.query(User).filter(User.email == user.email).first()
    
    if not user_db:
        raise HTTPException(400, "User with this email does not exist!")
    
    match_pw = bcrypt.checkpw(user.password.encode(), user_db.password)
    
    if not match_pw:
        raise HTTPException(400, "Incorrect Password!")
    
    token = jwt.encode({'id': user_db.id}, 'password_key')
    
    return {'token': token, 'user': user_db} 

@router.get('/')
def current_user_data(db: Session=Depends(db.get_db), user_dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).first()
    
    if not user:
        raise HTTPException(400, 'User not found')
    
    return user