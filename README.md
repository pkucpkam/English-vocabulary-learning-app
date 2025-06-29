# English Vocabulary Learning App

## Overview
This project consists of two main components:
1. **Data Crawling**: A Python script that scrapes word meanings from the **Cambridge Dictionary** for the **Oxford 3000** word list and generates a JSON file.
2. **Flutter Application**: A mobile app built with Flutter to help users learn English vocabulary using the generated JSON data.

## Project Structure
- `/app`: Flutter application source code.
  - `/lib`: Dart files for UI and logic.
  - `/data`: Stores the JSON file with vocabulary data.
- `/scripts`: Python script for data scraping.
  - `scraper.py`: Script to fetch meanings and generate the JSON file.
- `vocabulary.json`: Output file containing words and their meanings.

## Part 1: Data Crawling

### Description
The data crawling component uses a Python script to extract meanings, examples, and other relevant information from the Cambridge Dictionary for the Oxford 3000 word list. The scraped data is saved into a JSON file for use in the Flutter app.

### How It Works
- **Input**: The script takes the Oxford 3000 word list as input (e.g., from a text file or predefined list).
- **Scraping Process**:
  - Sends HTTP requests to the Cambridge Dictionary website for each word.
  - Uses `BeautifulSoup` to parse the HTML and extract relevant data (e.g., word, meanings, example sentences).
  - Handles multiple senses of a word (e.g., noun, verb) and associated examples.
- **Output**: Generates a JSON file (`vocabulary.json`) with structured data:
  ```json
  [
    {
    "word": "abandon",
    "meanings": [
      {
        "meaning": "từ bỏ",
        "example": "The bank robbers abandoned the stolen car ."
      },
      {
        "meaning": "hủy",
        "example": "The match had to be abandoned because of the bad weather ."
      },
      {
        "meaning": "buông thả",
        "example": "After his wife’s death , he abandoned himself to despair ."
      }
    ],
    "pronunciation_uk": "əˈbӕndən",
    "audio": "abandon.mp3"
  },
    ...
  ]
  ```
- **Error Handling**: Includes checks for network issues, missing data, or changes in the website’s HTML structure to ensure robust scraping.


## Part 2: Flutter Application

### Description
The Flutter app provides an interactive interface for learning English vocabulary. It uses the `vocabulary.json` file to display words, meanings, and examples, with features like quizzes, flashcards, and progress tracking.

### Prerequisites
- Flutter SDK (version 3.x or higher).
- Dart (included with Flutter).
- Android Studio or VS Code for development.

### Setup Instructions
1. **Set Up the Flutter Environment**:
   - Ensure Flutter is installed and configured. Run:
     ```bash
     flutter doctor
     ```

2. **Install App Dependencies**:
   - Navigate to the `/app` directory:
     ```bash
     cd app
     ```
   - Install dependencies:
     ```bash
     flutter pub get
     ```

3. **Run the App**:
   - Launch the app on an emulator or device:
     ```bash
     flutter run
     ```

### Features
- Displays vocabulary from the Oxford 3000 list.
- Includes interactive learning tools:
  - Flashcards for quick review.
  - Listen to pronunciation of vocabulary words
  - Quizzes to test vocabulary knowledge.
  - Progress tracking to monitor learning achievements.

## Data Source
- **Vocabulary**: Oxford 3000 word list.
- **Meanings**: Cambridge Dictionary (scraped programmatically).

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
