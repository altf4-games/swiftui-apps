# swiftui-apps

A collection of small SwiftUI practice apps built for coursework at K. J. Somaiya
College of Engineering. Each folder is a self-contained Xcode project — open the
`.xcodeproj` inside it and run on the iOS Simulator.

## Apps

| Folder | Xcode project | Scheme | Bundle ID | What it does |
| --- | --- | --- | --- | --- |
| [Book Library](Book%20Library) | `exp3_swiftui.xcodeproj` | `exp3_swiftui` | `com.kjsce.exp3-swiftui` | A KJSCE library browser — tabbed UI with a searchable list of books by title/author and category icons. |
| [College App](College%20App) | `exp2_swiftui.xcodeproj` | `exp2_swiftui` | `com.kjsce.exp2-swiftui` | "Campus Connect" — a five-tab college guide covering Home, Departments, Faculty, Facilities and Contact. |
| [Health Tracker](Health%20Tracker) | `Health Tracker.xcodeproj` | `Health Tracker` | `com.altf4games.Health-Tracker` | Weight, BMI and daily water tracking with a profile setup flow and history charts. Uses SwiftData for persistence. |
| [ID](ID) | `Exp.xcodeproj` | `Exp` | `edu.kjsce.Exp` | A student ID card view with a generated QR code screen. |
| [WeatherForecast](WeatherForecast) | `WeatherForecast.xcodeproj` | `WeatherForecast` | `com.altf4games.WeatherForecast` | Search any city and see its current conditions and a 7-day forecast, fetched live from the Open-Meteo REST API with `URLSession` + `Codable`. Three screens: search/home, current details, forecast. |
| [Notes App](Notes%20App) | `Notes App.xcodeproj` | `Notes App` | `devplaceholder.*` (Xcode placeholder) | Create, view, edit and delete notes with search. Persisted with SwiftData (`@Model`, `ModelContainer`, `ModelContext`, `@Query`). Four screens: notes list, add, detail, edit. Liquid Glass styling. |
| [Calling Simulation](Calling%20Simulation) | `Calling Simulation.xcodeproj` | `Calling Simulation` | `com.altf4games.CallingSimulation` | A simulated phone app built to show off SwiftUI animations and transitions: zoom transition from contact to call screen, pulsing ringing rings, `phaseAnimator` wiggling answer button, `matchedGeometryEffect` end button, numeric-text call timer, SF Symbol replace effects, keypad scale transitions and an animated call log. Three screens: contacts, recents, in-call (outgoing + simulated incoming). |
| [Random Image](Random%20Image) | `Random Image.xcodeproj` | `Random Image` | `com.altf4games.RandomImage` | Random photos from the Picsum Photos API loaded with `AsyncImage`, covering all three phases (loading, success, failure + retry). Grayscale/blur via URL parameters, recently viewed strip, gallery grid and photo detail with share link. |
| [Campus Navigation](Campus%20Navigation) | `Campus Navigation.xcodeproj` | `Campus Navigation` | `com.altf4games.CampusNavigation` | Experiment 7 – MapKit campus map with facility markers, nearby libraries sorted by distance from the user's location, library details with book availability, book search across libraries, and walking/driving directions via `MKDirections`. Library and book data stored with SwiftData. |

> The folder names are friendly labels; the Xcode project names inside them
> (`exp2_swiftui`, `exp3_swiftui`, `Exp`) are the original assignment names and
> are unchanged, so all projects open and build normally.

## Requirements

- Xcode 26 or newer
- iOS 26 Simulator (deployment targets: 26.0–26.5)
- Swift 5

## Running an app

```bash
open "Book Library/exp3_swiftui.xcodeproj"
```

Then pick an iOS Simulator and press Run (⌘R). Or from the command line:

```bash
xcodebuild -project "Book Library/exp3_swiftui.xcodeproj" -scheme exp3_swiftui -destination 'platform=iOS Simulator,name=iPhone 16' build
```

## Repository layout

This is a single Git repository containing all nine projects. `Health Tracker`
and `WeatherForecast` (formerly `Weather App`) previously had their own nested Git
repositories; they have been
folded into this one so everything lives under a single history and remote.
