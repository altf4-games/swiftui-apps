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

> The folder names are friendly labels; the Xcode project names inside them
> (`exp2_swiftui`, `exp3_swiftui`, `Exp`) are the original assignment names and
> are unchanged, so all projects open and build normally.

## Requirements

- Xcode 26 or newer
- iOS 26 Simulator (deployment targets: 26.2–26.5)
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

This is a single Git repository containing all four projects. `Health Tracker`
previously had its own nested Git repository; it has been folded into this one so
everything lives under a single history and remote.
