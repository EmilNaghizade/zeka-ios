# Zəka — iOS Quiz Game

A native Azerbaijani quiz app built with SwiftUI and SwiftData.
Answer 15 questions to reach a virtual prize of ₼1,000,000.

## Features

- 60 questions across three difficulty levels
- Random selection of 5 easy, 5 medium, and 5 hard questions
- Shuffled answer options
- Three lifelines: 50:50, audience poll, and phone a friend
- Final answer confirmation and automatic question progression
- Guaranteed prize milestones and voluntary withdrawal
- Local game history, personal best, and million-prize win count
- Victory animation and confetti
- Result sharing and configurable haptic feedback

Audience polls and phone-a-friend advice are simulated.
All prizes are virtual; no real money is awarded.

## Technology

- Swift and SwiftUI
- Observation for game state
- SwiftData for persistent game results
- Local JSON question bank with validation
- AppStorage for preferences

## Project Structure

- `App` — application entry point
- `Core` — theme and formatting utilities
- `Models` — questions, prize ladder, and game results
- `Features` — game, home, history, settings, and rules
- `Services` — question loading and validation

## Run Locally

1. Clone the repository:

   ```bash
   git clone https://github.com/EmilNaghizade/zeka-ios.git
   ```

2. Open `Zeka.xcodeproj` in Xcode.
3. Select an iOS 17 or later simulator and run.
4. For a physical iPhone, select your signing team first.

## Screenshots

<p>
  <img src="docs/screenshots/home.png" width="220" alt="Home and statistics">
  <img src="docs/screenshots/game.png" width="220" alt="Quiz gameplay">
  <img src="docs/screenshots/audience.png" width="220" alt="Audience lifeline">
  <img src="docs/screenshots/history.png" width="220" alt="Game history">
</p>

## About

Created as a hands-on project to learn native iOS development
with Swift and SwiftUI.

The app interface and question bank are in Azerbaijani.
