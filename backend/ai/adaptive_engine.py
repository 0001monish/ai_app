def adjust_difficulty(accuracy: float) -> str:
    if accuracy > 0.85: return "hard"
    if accuracy < 0.5: return "easy"
    return "medium"