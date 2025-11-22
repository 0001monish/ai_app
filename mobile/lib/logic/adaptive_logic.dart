class AdaptiveLogic {
  static String getNextDifficulty(double accuracy) {
    if (accuracy > 0.85) return "hard";
    if (accuracy < 0.5) return "easy";
    return "medium";
  }

  static String getFeedback(double accuracy) {
    if (accuracy >= 0.9) return "Excellent! You're mastering this!";
    if (accuracy >= 0.7) return "Great job! Keep going!";
    if (accuracy >= 0.5) return "Good effort. Let's review.";
    return "Let's try easier questions first.";
  }
}
