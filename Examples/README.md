# GridNavigation Examples

This directory contains comprehensive examples demonstrating the capabilities of the GridNavigation SwiftUI library. Each example showcases different use cases and features of the library.

## 📁 Available Examples

### 1. Movie Catalog Example (`MovieCatalogExample.swift`)
A comprehensive movie database interface demonstrating:

**Features:**
- **Advanced Filtering**: Search by title, director, or genre
- **Multiple Sort Options**: Rating, title, year, duration
- **Interactive Elements**: Watch Later functionality with state management  
- **Rich Detail Views**: Complete movie information with ratings and descriptions
- **Visual Polish**: Color-coded movie posters and rating badges

**Key Components:**
- `MovieCatalogExample` - Main catalog view with search and filters
- `MoviePosterCard` - Interactive movie card with hover effects
- `MovieDetailView` - Comprehensive detail view with escape key support
- `Movie` - Data model with sample movie collection

**Best For:** Learning complex state management, search/filter implementation, and rich visual presentations.

### 2. Photo Gallery Example (`PhotoGalleryExample.swift`)
A feature-rich photo gallery interface demonstrating:

**Features:**
- **Dual View Modes**: Grid and list layouts with seamless switching
- **Advanced Filtering**: By tags, favorites, search text, and date
- **Metadata Display**: File sizes, dimensions, creation dates
- **Tag Management**: Visual tag system with flow layout
- **Favorites System**: Heart-based favorite toggling with visual feedback

**Key Components:**
- `PhotoGalleryExample` - Main gallery with dual view modes
- `PhotoThumbnailCard` - Grid view photo cards with hover effects
- `PhotoListRow` - Detailed list row layout
- `PhotoDetailView` - Full-screen photo view with metadata
- `FlowLayout` - Custom layout for tag display
- `Photo` - Data model with realistic photo metadata

**Best For:** Understanding layout switching, metadata handling, and custom SwiftUI layouts.

### 3. Product Catalog Example (`ProductCatalogExample.swift`)
A complete e-commerce product catalog demonstrating:

**Features:**
- **Multi-Level Filtering**: Category, availability, price range, sale status
- **E-commerce Elements**: Sale badges, stock indicators, ratings
- **Interactive Actions**: Add to cart, wishlist functionality
- **Rich Product Data**: Categories, pricing, features, availability
- **Professional Polish**: Hover effects, status indicators, and comprehensive details

**Key Components:**
- `ProductCatalogExample` - Main catalog with extensive filtering
- `ProductCard` - E-commerce style product cards
- `ProductListRow` - Detailed product list layout
- `ProductDetailView` - Complete product information page
- `Product` - Comprehensive product data model
- `ProductCategory` & `ProductAvailability` - Enum-based categorization

**Best For:** Learning complex filtering systems, e-commerce UI patterns, and professional app development.

## 🚀 Running the Examples

### Using Xcode
1. Open the `GridNavigationExample` project in the Examples directory
2. The main example app includes all three examples in a tabbed interface
3. Build and run to see all examples in action

### Integrating into Your Project
Each example file is self-contained and can be copied into your project:

```swift
import SwiftUI
import GridNavigation

// Copy any of the example views
struct ContentView: View {
    var body: some View {
        NavigationStack {
            MovieCatalogExample()  // or PhotoGalleryExample(), ProductCatalogExample()
        }
    }
}
```

## 🎓 Learning Path

**Beginner**: Start with the basic example in the main README, then explore `MovieCatalogExample` for fundamental concepts.

**Intermediate**: Study `PhotoGalleryExample` to learn about view mode switching and custom layouts.

**Advanced**: Examine `ProductCatalogExample` for complex filtering and professional e-commerce patterns.

## 🔧 Customization Examples

### Custom Data Models
Each example shows how to implement the `GridNavigable` protocol:

```swift
struct MyItem: GridNavigable {
    let id = UUID()
    let title: String
    let customProperty: String
}
```

### Different Grid Configurations
Examples demonstrate various grid setups:

- **Fixed Columns**: `columnCount: 3, columnWidth: 180`
- **Adaptive Layout**: `minItemWidth: 150, maxItemWidth: 200`
- **Custom Columns**: Using `GridItem` arrays for precise control

### Platform-Specific Features
All examples include:
- **macOS**: Full keyboard navigation with escape key support
- **iOS**: Touch-based navigation with native transitions
- **Cross-platform**: Conditional compilation for platform-specific features

## 📱 Platform Support

- **iOS 17.0+**
- **macOS 14.0+**
- **Swift 5.9+**
- **SwiftUI**

## 🎨 Design Patterns Demonstrated

### State Management
- `@State` for local UI state
- Data model updates with immutable patterns
- Search and filter state coordination

### Performance Optimization
- Lazy loading with `LazyVGrid`
- Efficient data filtering and sorting
- Minimal state updates

### UI/UX Best Practices
- Loading states and empty states
- Accessibility considerations
- Keyboard navigation support
- Responsive design patterns

## 🤝 Contributing

Found a bug in an example or have an improvement suggestion?

1. Check the main project's [contributing guidelines](../CONTRIBUTING.md)
2. Open an issue describing the problem or enhancement
3. Submit a pull request with your changes

## 📄 License

These examples are part of the GridNavigation library and are available under the same MIT License. See the main [LICENSE](../LICENSE) file for details.

---

**Need Help?**
- 📖 [Main Documentation](../README.md)
- 🐛 [Report Issues](https://github.com/jjnicolas/GridNavigation/issues)
- 💡 [Feature Requests](https://github.com/jjnicolas/GridNavigation/discussions)