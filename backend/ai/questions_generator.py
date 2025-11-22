from .local_inference import run_llama_cpp
import json
from pathlib import Path

PROMPT_FILE = Path("../intellilearn_prompt.txt")

def generate_questions(text: str, accuracy: float = 0.7) -> dict:
    with open(PROMPT_FILE) as f:
        base_prompt = f.read()

    difficulty = "medium"
    if accuracy > 0.85: difficulty = "hard"
    elif accuracy < 0.5: difficulty = "easy"

    full_prompt = f"{base_prompt}\n\nDifficulty: {difficulty}\n\nText:\n{text}\n\nOutput JSON only."
    raw = run_llama_cpp(full_prompt)
    try:
        return json.loads(raw)
    except:
        return {"summary": "Failed to parse AI", "questions": []}