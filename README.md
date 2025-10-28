# TMDB_Assignment_Cricbuzz

A simple and elegant **iOS Movie App** built using **UIKit (Storyboard)** in **MVVM architecture**, powered by **The Movie Database (TMDb)** API.

This app displays Movies List, lets you search for titles, view detailed information (including trailers, cast, and genres), and manage your favorite movies — all with local persistence.

## 📱 Features

### 🏠 Home Screen
- Displays **Movies List** fetched from TMDb.
- Each movie shows:
  - Poster  
  - Title  
  - Rating  
  - Duration (fetched dynamically from the movie details API)
- Tap a movie to view full details.
- Search movies by title smooth and efficient.

### 🎥 Movie Detail Screen
- Shows:
  - Poster  
  - Title, Rating, Duration, Genres  
  - Plot/Overview  
  - Cast List (horizontal scroll Please Note that there was no API or Data for Cast so binded Static data)
- **Trailer player** embedded inline using `WKWebView` (YouTube integration).
- “Open in YouTube” fallback using `SFSafariViewController`.

### ❤️ Favorites
- Mark/unmark any movie as favorite from the list or detail screen.
- Favorites are stored using `UserDefaults` and restored on app relaunch.
- Visual heart indicator for favorited movies.

### 🔍 Search
- Search by movie title (using TMDb search endpoint).
- Debounced to reduce API calls.
- Clean “No Results” and “Error” states.

---

## 🧱 Architecture

The app follows **MVVM** (Model–View–ViewModel) with clear separation of concerns.


