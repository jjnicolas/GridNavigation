# How to Run GridNavigation Examples

## 🚀 Quick Start

### Option 1: Create a New App Project (Recommended)

Due to bundle identifier limitations with Swift Package executables, the best way to run these examples is:

1. **Create a new iOS or macOS app** in Xcode
2. **Add GridNavigation dependency:**
   - File → Add Package Dependencies
   - Enter: `https://github.com/jjnicolas/GridNavigation`
3. **Copy any example file** into your project
4. **Use it in your app:**
   ```swift
   @main
   struct MyApp: App {
       var body: some Scene {
           WindowGroup {
               MovieCatalogExample()  // or PhotoGalleryExample(), etc.
           }
       }
   }
   ```

### Option 2: Using Xcode with Package (Limited)

1. **Open the workspace in Xcode:**
   ```bash
   open "GridNavigationExample/.swiftpm/xcode/package.xcworkspace"
   ```

2. **Run the example:**
   - Select the "GridNavigationExample" scheme
   - Choose your target platform (iOS Simulator or Mac)
   - Press the Run button (▶️) or use Cmd+R

*Note: You may encounter bundle identifier warnings, but the examples will still work.*

### Option 2: Copy Examples to Your Project

The comprehensive examples (`MovieCatalogExample.swift`, `PhotoGalleryExample.swift`, `ProductCatalogExample.swift`) are self-contained and can be copied directly into any SwiftUI project.

**Steps:**
1. Create a new iOS/macOS app in Xcode
2. Add GridNavigation as a package dependency:
   ```
   https://github.com/jjnicolas/GridNavigation
   ```
3. Copy any of the example files into your project
4. Use the example view in your app:
   ```swift
   import SwiftUI

   @main
   struct MyApp: App {
       var body: some Scene {
           WindowGroup {
               MovieCatalogExample()  // or PhotoGalleryExample(), ProductCatalogExample()
           }
       }
   }
   ```

## 📱 Example Features

### Basic Example (in main.swift)
- Simple movie and photo grid
- Basic keyboard navigation
- NavigationLink integration

### Comprehensive Examples

#### 🎬 Movie Catalog (`MovieCatalogExample.swift`)
- Search and filter movies
- Watch Later functionality
- Rich detail views
- Rating system

#### 📸 Photo Gallery (`PhotoGalleryExample.swift`)
- Grid and list view modes
- Tag-based filtering
- Favorites system
- Metadata display

#### 🛒 Product Catalog (`ProductCatalogExample.swift`)
- E-commerce interface
- Multi-level filtering
- Shopping cart simulation
- Stock management

## 🛠 Troubleshooting

### "App exits with code 0 without showing UI"
This is expected behavior when running SwiftUI apps as Swift Package executables. SwiftUI apps need a proper app bundle environment.

**Solutions:**
- Use Xcode to run the examples (Option 1 above)
- Copy examples to a regular iOS/macOS app project (Option 2 above)

### "'main' attribute cannot be used in a module that contains top-level code"
This error has been fixed by restructuring the main.swift file to use `GridNavigationExampleApp.main()` instead of the `@main` attribute.

### "Cannot index window tabs due to missing main bundle identifier"
This is a limitation of Swift Package executables. The examples will still run, but you may see this warning.

**Best Solution:** Create a regular iOS/macOS app project and copy the examples there (Option 1 above).

### "Cannot find GridNavigation in scope"
Make sure you've added the GridNavigation package dependency to your project:
1. File → Add Package Dependencies...
2. Enter: `https://github.com/jjnicolas/GridNavigation`
3. Add to your target

### Build Errors
Ensure you're using:
- iOS 17.0+ or macOS 14.0+
- Swift 5.9+
- Xcode 15.0+

## 🎯 Platform-Specific Features

### macOS
- Full keyboard navigation (arrow keys, return, escape)
- Focus rings and indicators
- Smooth scrolling to focused items

### iOS
- Touch-based navigation
- Standard iOS transitions
- Native back gesture support

## 📝 Integration Tips

1. **Start Simple:** Begin with the basic examples in `main.swift`
2. **Add Features:** Explore comprehensive examples for advanced patterns
3. **Customize:** Modify data models and UI to fit your needs
4. **Test Navigation:** Try keyboard navigation on macOS and touch on iOS

## 🔗 Related Documentation

- [Main README](../README.md) - Library overview and basic usage
- [Examples README](README.md) - Detailed example documentation
- [API Documentation](../Sources/GridNavigation/) - Source code reference