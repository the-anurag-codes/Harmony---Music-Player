from sqlalchemy import TEXT, VARCHAR, Column
from models.base import Base


class Song(Base):
    __tablename__ = 'songs'
    
    id = Column(TEXT, primary_key=True)
    song_name = Column(TEXT)
    artist = Column(TEXT)
    song_url = Column(TEXT)
    thumbnail_url = Column(TEXT)
    hex_code = Column(VARCHAR(6))