# GridNavigation Quick Start Guide

## 🎯 Fastest Way to Try the Examples

### Step 1: Create New App in Xcode
1. Open Xcode
2. Create a new iOS or macOS app project
3. Name it "GridNavigationDemo" (or any name)
4. Choose SwiftUI interface

### Step 2: Add GridNavigation Package
1. In Xcode: File → Add Package Dependencies
2. Enter URL: `https://github.com/jjnicolas/GridNavigation`
3. Click "Add Package"
4. Select "GridNavigation" and click "Add Package"

### Step 3: Replace ContentView.swift
Copy and paste this into your ContentView.swift file:

```swift
import SwiftUI
import GridNavigation

// Simple Movie Example
struct Movie: GridNavigable {
    let id = UUID()
    let title: String
    let year: Int
    let genre: String
    let rating: Double
}

struct ContentView: View {
    let movies = [
        Movie(title: "The Matrix", year: 1999, genre: "Sci-Fi", rating: 8.7),
        Movie(title: "Inception", year: 2010, genre: "Thriller", rating: 8.8),
        Movie(title: "Interstellar", year: 2014, genre: "Sci-Fi", rating: 8.6),
        Movie(title: "The Dark Knight", year: 2008, genre: "Action", rating: 9.0),
        Movie(title: "Pulp Fiction", year: 1994, genre: "Crime", rating: 8.9),
        Movie(title: "Fight Club", year: 1999, genre: "Drama", rating: 8.8),
        Movie(title: "Goodfellas", year: 1990, genre: "Crime", rating: 8.7),
        Movie(title: "The Shawshank Redemption", year: 1994, genre: "Drama", rating: 9.3)
    ]
    
    var body: some View {
        NavigationStack {
            GridNavigationView(
                items: movies,
                columnCount: 3,
                columnWidth: 160
            ) { movie in
                // Movie Card
                NavigationLink(value: movie) {
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 120)
                            .overlay(
                                VStack {
                                    Image(systemName: "film")
                                        .font(.system(size: 30))
                                        .foregroundStyle(.white)
                                    
                                    Text("★ \(movie.rating, specifier: "%.1f")")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(.black.opacity(0.3), in: Capsule())
                                }
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.headline)
                                .lineLimit(2)
                            
                            HStack {
                                Text("\(movie.year)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text("•")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(movie.genre)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .frame(width: 140)
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            } detailContent: { movie in
                // Movie Detail View
                VStack(alignment: .leading, spacing: 20) {
                    // Movie Poster
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 300)
                        .overlay(
                            VStack {
                                Image(systemName: "film")
                                    .font(.system(size: 80))
                                    .foregroundStyle(.white)
                                
                                Text(movie.title)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                            }
                        )
                    
                    // Movie Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text(movie.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("\(movie.year)")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                Text("\(movie.rating, specifier: "%.1f")/10")
                                    .fontWeight(.semibold)
                            }
                            .font(.title2)
                        }
                        
                        Text("Genre: \(movie.genre)")
                            .font(.title3)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Movie Details")
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationTitle("Movie Collection")
        }
    }
}

#Preview {
    ContentView()
}
```

### Step 4: Run Your App! 🚀

Press **Cmd+R** to build and run. You'll see:

- **Grid of movies** with keyboard navigation (macOS) or touch navigation (iOS)
- **Arrow key navigation** on macOS
- **Return key** to open details on macOS
- **Escape key** to close details on macOS
- **Touch to navigate** on iOS

## 🎉 You're Done!

You now have a fully working GridNavigation example. Try:

- **macOS**: Use arrow keys to navigate, Return to open, Escape to close
- **iOS**: Tap cards to navigate, use back gesture

## 🔥 Want More Advanced Examples?

Copy the comprehensive examples from the Examples directory:
- `MovieCatalogExample.swift` - Advanced movie catalog with search/filters
- `PhotoGalleryExample.swift` - Photo gallery with grid/list modes
- `ProductCatalogExample.swift` - E-commerce product catalog

Just copy any of these files into your project and use them as your ContentView!

## 💡 Next Steps

1. **Customize the data model** - Add your own properties
2. **Style the cards** - Change colors, fonts, layouts
3. **Add more features** - Search, filters, categories
4. **Explore keyboard shortcuts** - Add custom key handlers

The GridNavigation library handles all the complex navigation logic while giving you complete control over the visual design!