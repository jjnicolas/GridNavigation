# GridNavigation

A high-performance, cross-platform SwiftUI grid navigation library with full keyboard support.

## Features

- 🚀 **High Performance**: O(1) navigation using direct array indexing
- ⌨️ **Full Keyboard Support**: Arrow keys, Return, and Escape on macOS
- 📱 **Cross-Platform**: Works on both iOS and macOS with platform-appropriate interactions
- 🎯 **Generic**: Supports any data type conforming to `GridNavigable`
- 🔧 **Flexible**: Multiple column layout options and customizable views
- ♿ **Accessible**: Built-in focus management and accessibility support

## Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 5.9+
- SwiftUI

## Installation

### Swift Package Manager

Add this package to your project using Xcode:

1. File → Add Package Dependencies...
2. Enter the package URL
3. Choose the version and add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-repo/GridNavigation", from: "1.0.0")
]
```

## Usage

### Basic Example

```swift
import SwiftUI
import GridNavigation

struct Movie: GridNavigable {
    let id = UUID()
    let title: String
    let year: Int
}

struct ContentView: View {
    let movies = [
        Movie(title: "The Matrix", year: 1999),
        Movie(title: "Inception", year: 2010),
        Movie(title: "Interstellar", year: 2014)
    ]
    
    var body: some View {
        NavigationStack {
            GridNavigationView(
                items: movies,
                columnCount: 3,
                columnWidth: 150
            ) { movie in
                // Cell content
                VStack {
                    Text(movie.title)
                        .font(.headline)
                    Text("\\(movie.year)")
                        .font(.caption)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            } detailContent: { movie in
                // Detail content
                VStack {
                    Text(movie.title)
                        .font(.largeTitle)
                    Text("Released in \\(movie.year)")
                        .font(.title2)
                }
                .padding()
            }
        }
    }
}
```

### Navigation Features

#### macOS
- **Arrow keys**: Navigate between grid items
- **Return key**: Open detail view
- **Escape key**: Close detail view (add to your detail views)
- **Focus indicators**: Automatic focus rings
- **Smooth scrolling**: Focused items stay in view

#### iOS
- **Touch navigation**: Tap to navigate
- **Swipe back**: Native iOS back gesture
- **Navigation transitions**: Standard iOS animations

### GridNavigable Protocol

Your data types must conform to `GridNavigable`:

```swift
struct MyItem: GridNavigable {
    let id = UUID()  // Required: Unique identifier
    let title: String
    let description: String
}
```

### Column Layout Options

#### Fixed Columns
```swift
GridNavigationView(
    items: items,
    columnCount: 4,
    columnWidth: 150
) { /* ... */ } detailContent: { /* ... */ }
```

#### Adaptive Columns
```swift
GridNavigationView(
    items: items,
    minItemWidth: 100,
    maxItemWidth: 200
) { /* ... */ } detailContent: { /* ... */ }
```

#### Custom Column Configuration
```swift
let customColumns = [
    GridItem(.flexible(minimum: 100)),
    GridItem(.fixed(150)),
    GridItem(.flexible(minimum: 100))
]

GridNavigationView(
    items: items,
    columns: customColumns
) { /* ... */ } detailContent: { /* ... */ }
```

### Adding Escape Key Support to Detail Views

For full keyboard support on macOS, add escape key handling to your detail views:

```swift
struct MovieDetailView: View {
    let movie: Movie
    @Environment(\\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text(movie.title)
                .font(.largeTitle)
            // ... other content
        }
        .padding()
        #if os(macOS)
        .onKeyPress(keys: [.escape]) { _ in
            dismiss()
            return .handled
        }
        #endif
    }
}
```

## Performance

This library is designed for high performance:

- **O(1) navigation**: Direct array index access instead of UUID searches
- **Lazy loading**: Uses SwiftUI's LazyVGrid for memory efficiency
- **Minimal state**: Only essential state is maintained
- **Platform optimization**: Keyboard features only compiled for macOS

## Examples

The library includes comprehensive examples:

- **Movie Grid**: Film catalog with ratings and genres
- **Photo Gallery**: Image grid with metadata
- **Product Catalog**: E-commerce style grid with availability

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions are welcome! Please see CONTRIBUTING.md for guidelines.