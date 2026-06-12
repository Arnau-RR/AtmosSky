# 🌤️ AtmosSky

A native iOS weather application built with SwiftUI. AtmosSky features a fully animated, reactive background that responds to real weather conditions and time of day — rain, storms, stars, and a live sun/moon arc that tracks the actual solar position.

![Platform](https://img.shields.io/badge/Platform-iOS-blue)
![Language](https://img.shields.io/badge/Language-Swift-orange)
![UI Framework](https://img.shields.io/badge/UI-SwiftUI-green)
![API](https://img.shields.io/badge/API-Open--Meteo-lightblue)
![Persistence](https://img.shields.io/badge/Persistence-SwiftData-purple)

---

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#️-tech-stack)
- [Installation](#-installation)
- [Project Structure](#-project-structure)
- [Architecture](#️-architecture)
- [Animated Background](#-animated-background)

---

## ✨ Features

- 🌡️ **Current weather** — Temperature, apparent temperature, humidity and wind speed
- ⏱️ **Hourly forecast** — 24-hour forecast with weather icons and correct local timezone
- 📅 **Daily forecast** — Multi-day forecast with min/max temperature range bar
- 🌅 **Sun/Moon arc** — Animated arc that tracks the real solar position based on sunrise and sunset times
- ⭐ **Favorites** — Save cities and quickly switch between them with live weather data
- 🔍 **City search** — Search any city in the world via geocoding
- 📍 **GPS location** — Automatic weather for the user's current location
- 🌧️ **Animated weather** — Rain (light/medium/heavy), lightning bolts, and stars rendered natively in SwiftUI
- 🌈 **Dynamic background** — Sky gradient changes in real time based on solar progress and weather conditions
- 🔄 **Pull to refresh** — Reload weather data with a swipe

---

## 🛠️ Tech Stack

| Category | Technology |
| --- | --- |
| **Language** | Swift |
| **UI Framework** | SwiftUI |
| **Architecture** | MVVM |
| **Persistence** | SwiftData |
| **Weather API** | Open-Meteo (free, no API key required) |
| **Location** | CoreLocation |
| **Geocoding** | CLGeocoder + MKReverseGeocodingRequest |
| **Dependency** | OpenMeteoSdk (Swift Package Manager) |

---

## 📦 Installation

1. Clone the repository:

```
git clone https://github.com/Arnau-RR/AtmosSky.git
```

2. Open `AtmosSky.xcodeproj` in Xcode.
3. Let Xcode resolve the Swift Package Manager dependency (`OpenMeteoSdk`).
4. Choose your simulator or a real device.
5. Build and run.

> Location features require a real device or a simulated location in Xcode.

---

## 📁 Project Structure

```
AtmosSky/
├── AtmosSky/
│   ├── Components/         # Reusable UI components
│   ├── Config/             # App configuration
│   ├── Models/             # Data models (User, UserEntity...)
│   ├── Persistence/        # SwiftData setup
│   ├── Resources/          # Assets and localization
│   ├── Services/           # API layer and protocol
│   ├── ViewModels/         # MainViewModel, ProfileViewModel
│   └── Views/              # MainView, ProfileView, UserListCell
│   └── Models/             # WeatherData, ForecastModels, FavoriteCity
├── AtmosSkyTests/
└── AtmosSky.xcodeproj
```

---

## 🏗️ Architecture

The project follows **MVVM** with protocol-based services for clean separation and testability:

- **Views** are declarative and observe ViewModel state only.
- **ViewModels** hold all business logic: weather fetching, timezone handling, favorites, and background conditions.
- **Services** are hidden behind protocols (`WeatherServiceProtocol`, `ReverseGeocodingServiceProtocol`), making them mockable for testing.
- **SwiftData** persists favorite cities via a `FavoriteCity` model.

### Timezone handling

A key detail: all hourly and daily forecasts use the **timezone of the queried location**, not the device timezone. This ensures that "Today", "Tomorrow", hourly labels, and the sun/moon arc are always correct for the city being viewed, regardless of where the user is.

---

## 🎨 Animated Background

The background is fully custom-built in SwiftUI with no external animation libraries:

**Sky gradient** — Transitions smoothly between dawn, day, dusk and night palettes based on the real solar progress (sunrise → sunset).

**Sun/Moon arc** — A semicircular arc rendered with `Path` that shows the current position of the sun during the day and the moon at night. Animated with fade-out → arc movement → fade-in to avoid jarring jumps.

**Rain** — Built with SwiftUI `Canvas` and `TimelineView` for GPU-efficient rendering. Three intensity levels (light, medium, heavy) with different drop counts, speeds, lengths and opacity.

**Lightning** — Procedurally generated bolt paths with random branching, rendered with a screen-blend flash effect. Frequency scales with storm intensity.

**Stars** — 120 randomly placed stars that fade in smoothly at night using `easeInOut` animation.

---
<p align="center">
Made with ❤️ as a personal iOS project
</p>

<p align="center">
  <a href="https://github.com/Arnau-RR/AtmosSky/issues">Report Bug</a>
  ·
  <a href="https://github.com/Arnau-RR/AtmosSky/issues">Request Feature</a>
</p>
