from fastapi import FastAPI, UploadFile, Form, HTTPException, File
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import os
import uuid
import json
from ai.question_generator import generate_questions
from ai.adaptive_engine import adjust_difficulty
from ai.vector_store import VectorStore
from utils.pdf_parser import extract_text_with_pages
from utils.ocr_extractor import ocr_pdf
from utils.speech_handler import SpeechHandler

app = FastAPI()
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

UPLOAD_DIR = "uploads"
AUDIO_DIR = "audio"
os.makedirs(UPLOAD_DIR, exist_ok=True)
os.makedirs(AUDIO_DIR, exist_ok=True)

vector_store = VectorStore()
speech = SpeechHandler()

class AnswerSubmit(BaseModel):
    question_id: str
    user_answer: str
    correct_answer: str

@app.post("/process-pdf")
async def process_pdf(file: UploadFile = None, text: str = Form(None), use_ocr: bool = Form(False)):
    uid = str(uuid.uuid4())
    if text:
        content = text
    elif file:
        path = f"{UPLOAD_DIR}/{uid}.pdf"
        with open(path, "wb") as f:
            f.write(await file.read())
        content = ocr_pdf(path) if use_ocr else "\n".join([f"Page {p}: {t}" for p, t in extract_text_with_pages(path)])
    else:
        raise HTTPException(400, "No input")

    chunks = [content[i:i+1000] for i in range(0, len(content), 1000)]
    vector_store.build(chunks)
    result = generate_questions(content)
    return {"pdf_id": uid, **result}

@app.post("/submit-answer")
async def submit_answer(answers: List[AnswerSubmit]):
    correct = sum(1 for a in answers if a.user_answer == a.correct_answer)
    total = len(answers)
    accuracy = correct / total if total > 0 else 0.0
    next_diff = adjust_difficulty(accuracy)
    return {
        "accuracy": accuracy,
        "next_difficulty": next_diff,
        "feedback": "Great job!" if accuracy > 0.7 else "Let's review!"
    }

@app.post("/voice-query")
async def voice_query(audio: UploadFile = File(...)):
    uid = str(uuid.uuid4())
    audio_path = f"{UPLOAD_DIR}/{uid}.wav"
    with open(audio_path, "wb") as f:
        f.write(await audio.read())

    user_text = speech.transcribe(audio_path)
    if not user_text.strip():
        user_text = "I didn't catch that. Please try again."

    ai_response = generate_questions(user_text + "\nAnswer as a friendly teacher.")["summary"]
    
    tts_path = f"{AUDIO_DIR}/{uid}.wav"
    speech.synthesize(ai_response, tts_path)

    return {
        "user_text": user_text,
        "ai_response": ai_response,
        "audio_url": f"/audio/{uid}.wav"
    }

@app.get("/audio/{filename}")
async def get_audio(filename: str):
    file_path = f"{AUDIO_DIR}/{filename}"
    if not os.path.exists(file_path):
        raise HTTPException(404, "Audio not found")
    return FileResponse(file_path, media_type="audio/wav")