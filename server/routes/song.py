from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session
import db
from middleware.auth_middleware import auth_middleware
import cloudinary
import cloudinary.uploader
from cloudinary.utils import cloudinary_url
import uuid

from models.song import Song

router = APIRouter()

cloudinary.config( 
    cloud_name = "do9bsfrts", 
    api_key = "181426841146574", 
    api_secret = "vExCfKTyz2ATPW5I8m3zmSdydZo", # Click 'View Credentials' below to copy your API secret
    secure=True
)

@router.post('/upload', status_code=201)
def upload_song(song: UploadFile = File(...), thumbnail:UploadFile = File(...), 
                artist: str = Form(...),song_name: str = Form(...), hex_code: str = Form(...),
                db: Session=Depends(db.get_db), auth_dict=Depends(auth_middleware)):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type='auto', folder=f'songs/${song_id}')
    print(song_res)
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_tpe='image', folder=f'songs/${song_id}')
    print(thumbnail_res)
    
    new_song = Song(
        id=song_id,
        song_name=song_name,
        artist=artist,
        thumbnail_url=thumbnail_res['url'],
        song_url=song_res['url'],
        hex_code=hex_code
    )
    
    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song

@router.get('/list')
def list_songs(db: Session=Depends(db.get_db), auth_details=Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs