# backend/download_models.py
import requests
import os
from pathlib import Path

def download_file(url, filename):
    print(f"Downloading {filename}...")
    response = requests.get(url, stream=True)
    total = int(response.headers.get('content-length', 0))
    
    with open(filename, 'wb') as f:
        for i, chunk in enumerate(response.iter_content(chunk_size=8192)):
            if chunk:
                f.write(chunk)
                if total > 0:
                    percent = (i * 8192) / total * 100
                    print(f"\r{percent:.1f}%", end="")
    print(f"\n✓ {filename} downloaded!")

if __name__ == "__main__":
    os.makedirs("models", exist_ok=True)
    os.chdir("models")
    
    # Llama 3
    download_file(
        "https://huggingface.co/TheBloke/Llama-3-8B-Instruct-GGUF/resolve/main/llama-3-8b-instruct-q4_0.gguf",
        "llama-3-8b-instruct-q4_0.gguf"
    )
    
    # Whisper Tiny
    download_file(
        "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin",
        "whisper-tiny.en"
    )