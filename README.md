# Expense Tracker

A simple **Flutter** expense tracking app that lets you add, view, and delete expenses. It shows a running **Total Spent** and groups each expense by **category**.

## Features

- Add a new expense (title, amount, category)
- View total spent and number of transactions
- Swipe to delete an expense
- Material 3 UI

## Screens / UX

- Home screen with a total-spent header and a list of transactions
- “Add Expense” button opens a bottom sheet form

## Categories

The app includes these built-in categories:

- Food
- Transport
- Shopping
- Health
- Entertainment
- Other

## Tech Stack

- Flutter / Dart
- Material 3

## Getting Started

### Prerequisites

- Flutter SDK installed
- A configured device/emulator (Android/iOS) or a browser for Flutter web

### Run locally

```bash
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

## Configuration Notes

- Currency label in the UI is currently **DH** (see `lib/main.dart`).

## Project Structure (high level)

- `lib/main.dart` — app entry point and UI
- `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/` — platform folders

## Contributing

PRs are welcome. For bigger changes, please open an issue first to discuss what you’d like to change.
