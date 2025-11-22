import subprocess
import json
from pathlib import Path

MODEL_PATH = Path("models/llama3-8b-instruct-q4_0.gguf")

def run_llama_cpp(prompt: str) -> str:
    if not MODEL_PATH.exists():
        return json.dumps({"error": "Llama model missing. Download GGUF to models/"})
    
    cmd = [
        "llama.cpp/main",
        "-m", str(MODEL_PATH),
        "--temp", "0.7",
        "--top-p", "0.9",
        "-n", "512",
        "-p", prompt
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout.strip()