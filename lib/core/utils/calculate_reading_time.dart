int calCulateReadingTime(String text) {
  final wordCount = text
      .split(RegExp(r'\s+'))
      .length; // Split the text into words using whitespace as a delimiter
  // final wordCount = words.length;
  final readingTime = (wordCount / 225)
      .ceil(); // Assuming an average reading speed of 225 words per minute
  return readingTime;
}
