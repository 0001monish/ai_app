import subprocess
import os
from pathlib import Path

class SpeechHandler:
    def __init__(self):
        self.whisper_model = "models/whisper-tiny.en"
        self.tts_model = "tts_models/en/ljspeech/tacotron2-DDC"

    def transcribe(self, audio_path: str) -> str:
        cmd = [
            "whisper.cpp/main",
            "-f", audio_path,
            "-m", self.whisper_model,
            "--output-txt"
        ]
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout.strip() or "No f speech detected."

    def synthesize(self, text: str, output_path: str):
        cmd = [
            "tts",
            "--text", text,
            "--model_name", self.tts_model,
            "--out_path", output_path
        ]
        subprocess.run(cmd, check=True)