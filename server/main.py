from fastapi import FastAPI, File, UploadFile, HTTPException, Form
from fastapi.middleware.cors import CORSMiddleware
from databases import Database
from pydantic import BaseModel
import os
import sqlite3
from datetime import datetime

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Initialize SQLite database
DATABASE_URL = "sqlite:///./test.db"
database = Database(DATABASE_URL)

# Pydantic model for login request
class LoginRequest(BaseModel):
    username: str
    password: str

class ImageUpload(BaseModel):
    description: str
    location: str
    time: str
# GET endpoint to fetch mill data
@app.get('/mill_data')
async def get_mill_data():
    query = "SELECT * FROM MILL_DATA"
    return await database.fetch_all(query)

# POST endpoint for login validation
@app.post('/login')
async def login(request: LoginRequest):
    query = "SELECT * FROM users WHERE username = :username AND password = :password"
    values = {"username": request.username, "password": request.password}
    result = await database.fetch_one(query, values)

    if result:
        return {"message": "Login successful"}
    else:
        raise HTTPException(status_code=401, detail="Invalid username or password")

# POST endpoint for QR data
@app.post('/qrdata')
async def post_qr_data(qrdata: dict):
    # Extract QR data
    extracted_data = extract_qr_data(qrdata['data'])

    # Insert QR code data into the table
    await insert_qr_code_data(extracted_data)

    return {"message": "QR data inserted successfully"}

# Helper function to extract QR data
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

# Helper function to insert QR code data
async def insert_qr_code_data(qr_code_data):
    # Insert QR code data into the table
    query = """
        INSERT INTO qr_code_data (plant, mill, heat_no, section, grade, bundle_no, length, weight, bc, pqd, date_today, time)
        VALUES (:plant, :mill, :heat_no, :section, :grade, :bundle_no, :length, :weight, :bc, :pqd, :date_today, :time)
    """
    await database.execute(query, **qr_code_data)

    return {"message": "QR code data inserted successfully"}

# POST request endpoint for image upload
@app.post('/upload')
async def upload_image(data: ImageUpload, file: UploadFile = File(...)):
    try:
        print(f"Received request with description: {data.description}, location: {data.location}, time: {data.time}")
        
        image_name = file.filename
        image_data = file.file.read()

        query = """
            INSERT INTO image_data (IMAGE_NAME, DESCRIPTION, LOCATION, UPLOAD_TIME, IMAGE_DATA)
            VALUES (:image_name, :description, :location, :upload_time, :image_data)
        """
        values = {
            "image_name": image_name,
            "description": data.description,
            "location": data.location,
            "upload_time": data.time,
            "image_data": image_data
        }
        
        print(f"Inserting data into the database: {values}")
        await database.execute(query, **values)

        return {"message": "Image uploaded successfully"}
    except Exception as e:
        print(f"Error uploading image: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error uploading image: {str(e)}")

# GET endpoint to fetch call data
@app.get('/call_data')
async def get_call_data():
    query = "SELECT * FROM call_data"
    return await database.fetch_all(query)

# Create SQLite tables on startup
@app.on_event("startup")
async def startup_db_client():
    await database.connect()
    with sqlite3.connect("test.db") as connection:
        cursor = connection.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY,
                username TEXT NOT NULL,
                password TEXT NOT NULL
            )
        """)
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS mill_data (
                id INTEGER PRIMARY KEY,
                millname TEXT,
                production_today INTEGER
            )
        """)
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS qr_code_data (
                id INTEGER PRIMARY KEY,
                plant TEXT,
                mill TEXT,
                heat_no TEXT NOT NULL,
                section TEXT,
                grade TEXT,
                bundle_no TEXT,
                length TEXT,
                weight REAL,
                bc TEXT,
                pqd TEXT,
                date_today TEXT,
                time TEXT
            )
        """)
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS image_data (
                id INTEGER PRIMARY KEY,
                image_name TEXT,
                description TEXT,
                location TEXT,
                upload_time TEXT,
                image_data BLOB
            )
        """)
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS call_data (
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL,
                designation TEXT NOT NULL,
                phone_number TEXT NOT NULL
            )
        """)

    user_check_query = "SELECT COUNT(*) FROM users"
    user_count = await database.fetch_val(user_check_query)
    if user_count == 0:
        await database.execute("""
            INSERT INTO users (username, password)
            VALUES 
            ('Abhishek', 'Pandey'),
            ('Akshat', 'Pandey')
        """)

    # Check if data exists before inserting into the 'call_data' table
    call_data_check_query = "SELECT COUNT(*) FROM call_data"
    call_data_count = await database.fetch_val(call_data_check_query)
    if call_data_count == 0:
        await database.execute("""
            INSERT INTO call_data (name, designation, phone_number)
            VALUES 
            ('Arun Kotnis', 'General Manager', '9407982428'),
            ('Akshat Pandey', 'Intern', '8770675685'),
            ('Abhishek Pandey', 'Intern', '9406448031'),
            ('Chandu Tembhurne', 'Deputy General Manager', '9407982416'),
            ('Tejkaran Hans', 'Senior Manager', '9407984187'),
            ('Shadma Khan', 'Manager', '9407982496'),
            ('Deepmala', 'Assistant Manager', '9407981806')
        """)

    # Check if data exists before inserting into the 'mill_data' table
    mill_data_check_query = "SELECT COUNT(*) FROM mill_data"
    mill_data_count = await database.fetch_val(mill_data_check_query)
    if mill_data_count == 0:
        await database.execute("""
            INSERT INTO mill_data (millname, production_today)
            VALUES 
            ('URM', 1000),
            ('BRM', 1500),
            ('SMS1', 800),
            ('SMS2', 1200),
            ('SMS3', 1400),
            ('BF8', 800)
        """)

    # Check if data exists before inserting into the 'qr_code_data' table
    qr_code_data_check_query = "SELECT COUNT(*) FROM qr_code_data"
    qr_code_data_count = await database.fetch_val(qr_code_data_check_query)
    if qr_code_data_count == 0:
        await database.execute("""
            INSERT INTO qr_code_data (plant, mill, heat_no, section, grade, bundle_no, length, weight, bc, pqd, date_today, time)
            VALUES 
            ('Plant1', 'Mill1', 'HeatNo1', 'Section1', 'Grade1', 'BundleNo1', 'Length1', 100.5, 'BC1', 'PQD1', '2022-01-15', '12:34:56'),
            ('Plant2', 'Mill2', 'HeatNo2', 'Section2', 'Grade2', 'BundleNo2', 'Length2', 150.7, 'BC2', 'PQD2', '2022-01-15', '14:45:32')
        """)

    # Check if data exists before inserting into the 'image_data' table
    image_data_check_query = "SELECT COUNT(*) FROM image_data"
    image_data_count = await database.fetch_val(image_data_check_query)
    if image_data_count == 0:
        await database.execute("""
            INSERT INTO image_data (image_name, description, location, upload_time)
            VALUES 
            ('Image1.jpg', 'Description1', 'Location1', '2022-01-15T12:00:00'),
            ('Image2.jpg', 'Description2', 'Location2', '2022-01-15T14:30:00')
        """)

# Close SQLite connection on shutdown
@app.on_event("shutdown")
async def shutdown_db_client():
    await database.disconnect()
