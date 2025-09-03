import SwiftUI
import GridNavigation

// Example data models
struct Movie: GridNavigable {
    let id = UUID()
    let title: String
    let year: Int
    let genre: String
    let rating: Double
}

struct Photo: GridNavigable {
    let id = UUID()
    let filename: String
    let size: CGSize
    let dateCreated: Date
}

// Example app
@main
struct GridNavigationExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var selectedExample = 0
    private let examples = ["Movies", "Photos"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Example Type", selection: $selectedExample) {
                    ForEach(0..<examples.count, id: \.self) { index in
                        Text(examples[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                Group {
                    switch selectedExample {
                    case 0:
                        MoviesExample()
                    case 1:
                        PhotosExample()
                    default:
                        MoviesExample()
                    }
                }
            }
        }
    }
}

struct MoviesExample: View {
    let movies = [
        Movie(title: "The Matrix", year: 1999, genre: "Sci-Fi", rating: 8.7),
        Movie(title: "Inception", year: 2010, genre: "Thriller", rating: 8.8),
        Movie(title: "Interstellar", year: 2014, genre: "Sci-Fi", rating: 8.6),
        Movie(title: "The Dark Knight", year: 2008, genre: "Action", rating: 9.0),
        Movie(title: "Pulp Fiction", year: 1994, genre: "Crime", rating: 8.9),
        Movie(title: "Fight Club", year: 1999, genre: "Drama", rating: 8.8)
    ]
    
    var body: some View {
        GridNavigationView(
            items: movies,
            columnCount: 3,
            columnWidth: 160
        ) { movie in
            MovieCellView(movie: movie)
        } detailContent: { movie in
            MovieDetailView(movie: movie)
        }
    }
}

struct PhotosExample: View {
    let photos = (1...20).map { i in
        Photo(
            filename: "IMG_\(String(format: "%04d", i)).jpg",
            size: CGSize(width: Int.random(in: 800...4000), height: Int.random(in: 600...3000)),
            dateCreated: Date().addingTimeInterval(TimeInterval(-i * 86400))
        )
    }
    
    var body: some View {
        GridNavigationView(
            items: photos,
            columnCount: 4,
            columnWidth: 130
        ) { photo in
            PhotoCellView(photo: photo)
        } detailContent: { photo in
            PhotoDetailView(photo: photo)
        }
    }
}

// MARK: - Cell Views

struct MovieCellView: View {
    let movie: Movie
    
    var body: some View {
        NavigationLink(value: movie) {
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text("\(movie.year)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Text(movie.genre)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    Text("★ \(movie.rating, specifier: "%.1f")")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
            .frame(width: 140, height: 120)
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

struct PhotoCellView: View {
    let photo: Photo
    
    var body: some View {
        NavigationLink(value: photo) {
            VStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundStyle(.white)
                    )
                
                Text(photo.filename)
                    .font(.caption)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .frame(width: 120, height: 140)
            .padding(4)
        }
    }
}

// MARK: - Detail Views

struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(movie.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack {
                Text("\(movie.year)")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("★ \(movie.rating, specifier: "%.1f")")
                    .font(.title2)
                    .foregroundStyle(.orange)
            }
            
            Text("Genre: \(movie.genre)")
                .font(.title3)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Movie Details")
        #if os(macOS)
        .onKeyPress(keys: [.escape]) { _ in
            dismiss()
            return .handled
        }
        #endif
    }
}

struct PhotoDetailView: View {
    let photo: Photo
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.4), .purple.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 300, height: 300)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Filename: \(photo.filename)")
                Text("Size: \(Int(photo.size.width)) × \(Int(photo.size.height))")
                Text("Created: \(photo.dateCreated.formatted())")
            }
            .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Photo Details")
        #if os(macOS)
        .onKeyPress(keys: [.escape]) { _ in
            dismiss()
            return .handled
        }
        #endif
    }
}