from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import firebase_admin
from firebase_admin import credentials, db
from datetime import datetime

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

cred = credentials.Certificate("firebase.json")
firebase_admin.initialize_app(cred, {"databaseURL": "https://mes-app-9c6f4-default-rtdb.asia-southeast1.firebasedatabase.app/"})

class LoginRequest(BaseModel):
    username: str
    password: str

class ImageUpload(BaseModel):
    description: str
    location: str
    time: str

class MillData(BaseModel):
    millname: str
    production_today: int

class QrCodeData(BaseModel):
    plant: str
    mill: str
    heat_no: str
    section: str
    grade: str
    bundle_no: str
    length: str
    weight: float
    bc: str
    pqd: str
    date_today: str
    time: str

class CallData(BaseModel):
    name: str
    designation: str
    phone_number: str

class UserData(BaseModel):
    username: str
    password: str

@app.post('/login')
async def login(request: LoginRequest):
    ref = db.reference('users')
    result = ref.order_by_child('username').equal_to(request.username).get()

    if result:
        user = list(result.values())[0]
        if user['password'] == request.password:
            return {"message": "Login successful"}

@app.post('/post_user')
async def post_user(user_data: UserData):
    ref = db.reference('users')
    ref.push({
        "username": user_data.username,
        "password": user_data.password
    })
    return {"message": "User added successfully"}


@app.get('/mill_data')
async def get_mill_data():
    ref = db.reference('mill_data')
    return ref.get()

@app.post('/qrdata')
async def post_qr_data(qrdata: dict):
    extracted_data = extract_qr_data(qrdata['data'])
    await insert_qr_code_data(extracted_data)
    return {"message": "QR data inserted successfully"}

def extract_qr_data(qr_scan_output):
    field_positions = {
        "plant": [5, 9],
        "mill": [16, 19],
        "heat_no": [31, 37],
        "section": [48, 62],
        "grade": [69, 83],
        "bundle_no": [95, 102],
        "length": [110, 114],
        "weight": [122, 128],
        "bc": [132, 134],
        "pqd": [139, 158],
        "date_today": [164, 173],
        "time": [179, 186]
    }

    extracted_data = {}

    for key, positions in field_positions.items():
        start, end = positions
        value = qr_scan_output[start - 1:end].strip()
        extracted_data[key] = value

    return extracted_data

async def insert_qr_code_data(qr_code_data):
    ref = db.reference('qr_code_data')
    heat_no_exists = ref.order_by_child('heat_no').equal_to(qr_code_data['heat_no']).get()

    if heat_no_exists:
        raise HTTPException(status_code=400, detail="Heat No already exists in the database")
    ref.push(qr_code_data)
    return {"message": "QR data inserted successfully"}

@app.post('/upload')
async def upload_image(data: ImageUpload, file: UploadFile = File(...)):
    try:
        print(f"Received request with description: {data.description}, location: {data.location}, time: {data.time}")
        
        image_name = file.filename
        image_data = file.file.read()

        ref = db.reference('image_data')
        ref.push({
            "image_name": image_name,
            "description": data.description,
            "location": data.location,
            "upload_time": data.time,
            "image_data": image_data.decode('utf-8')
        })

        return {"message": "Image uploaded successfully"}
    except Exception as e:
        print(f"Error uploading image: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error uploading image: {str(e)}")

@app.get('/call_data')
async def get_call_data():
    ref = db.reference('call_data')
    return ref.get()

@app.post('/post_mill_data')
async def post_mill_data(mill_data: MillData):
    ref = db.reference('mill_data')
    ref.push({
        "millname": mill_data.millname,
        "production_today": mill_data.production_today
    })
    return {"message": "Mill data posted successfully"}

@app.post('/post_call_data')
async def post_call_data(call_data: CallData):
    ref = db.reference('call_data')
    ref.push(call_data.dict())
    return {"message": "Call data posted successfully"}

@app.post('/post_qr_code_data')
async def post_qr_code_data(qr_code_data: QrCodeData):
    ref = db.reference('qr_code_data')
    ref.push(qr_code_data.dict())
    return {"message": "QR code data posted successfully"}


