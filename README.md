# Inshorts Movie App

This project is a Flutter app that shows movies using data from The Movie Database (TMDB)
API.

## Getting Started

Here are the steps to get up and running:

### 1. Install Flutter

If you haven’t already, set up Flutter on your machine. You can find instructions in
the [official docs](https://flutter.dev/docs/get-started/install).

### 2. Set Up the .env File

1. In the root of this project, create a file called `.env`.
2. Add your TMDB API key to it. Get your key from [TMDB’s website](https://www.themoviedb.org/).

Your `.env` file should look like this:

```
TMDB_API_KEY=your_actual_api_key_here
```

### 3. Install Dependencies

Open a terminal in the project root and run:

```
flutter pub get
```

### 4. Run the App

To start the app on a connected device or emulator:

```
flutter run
```

---

That’s it! If you run into issues, double-check your Flutter install and the API key in `.env`.
