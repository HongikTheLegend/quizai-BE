from pydantic import BaseModel, EmailStr


class UserBase(BaseModel):
    email: EmailStr
    name: str


class UserCreate(UserBase):
    password: str
    role: str = "student"  # student | instructor | admin


class UserResponse(UserBase):
    id: str
    role: str

    class Config:
        from_attributes = True
