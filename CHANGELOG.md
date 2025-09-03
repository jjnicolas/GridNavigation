# Changelog

## [1.0.0] - 2025-09-02

### Added
- Initial release of GridNavigation Swift Package
- `GridNavigationView` - High-performance generic grid navigation component
- `GridNavigable` protocol for type-safe data models
- Full keyboard navigation support on macOS (arrow keys, return, escape)
- Touch navigation support on iOS via NavigationLink
- O(1) navigation performance using direct array indexing
- Cross-platform compatibility (iOS 17.0+, macOS 14.0+)
- Multiple column layout options (fixed, adaptive, custom)
- Comprehensive documentation and examples
- Unit tests for core functionality

### Platform Support
- **macOS 14.0+**: Full keyboard navigation with focus management
- **iOS 17.0+**: Touch-optimized navigation with native gestures

### Features
- Generic support for any data type conforming to `GridNavigable`
- Customizable cell and detail views via ViewBuilder
- Automatic scrolling to keep focused items in view
- Focus restoration after navigation
- Platform-appropriate UI colors and behaviors