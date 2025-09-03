import SwiftUI
import GridNavigation

// MARK: - Movie Model

struct Movie: GridNavigable {
    let id = UUID()
    let title: String
    let year: Int
    let genre: String
    let rating: Double
    let director: String
    let duration: Int // minutes
    let description: String
    let posterColor: Color
    let isWatchLater: Bool
    
    static let sampleMovies: [Movie] = [
        Movie(title: "The Matrix", year: 1999, genre: "Sci-Fi", rating: 8.7, director: "Lana Wachowski", duration: 136, description: "A computer programmer discovers reality is a simulation and joins a rebellion against the machines.", posterColor: .green, isWatchLater: false),
        Movie(title: "Inception", year: 2010, genre: "Thriller", rating: 8.8, director: "Christopher Nolan", duration: 148, description: "A thief enters people's dreams to steal secrets but must plant an idea instead.", posterColor: .blue, isWatchLater: true),
        Movie(title: "Interstellar", year: 2014, genre: "Sci-Fi", rating: 8.6, director: "Christopher Nolan", duration: 169, description: "Explorers travel through a wormhole to save humanity from Earth's declining environment.", posterColor: .orange, isWatchLater: false),
        Movie(title: "The Dark Knight", year: 2008, genre: "Action", rating: 9.0, director: "Christopher Nolan", duration: 152, description: "Batman faces the Joker, a criminal mastermind who wants to plunge Gotham into anarchy.", posterColor: .black, isWatchLater: false),
        Movie(title: "Pulp Fiction", year: 1994, genre: "Crime", rating: 8.9, director: "Quentin Tarantino", duration: 154, description: "Interconnected stories of Los Angeles criminals, including two hit men and a boxer.", posterColor: .yellow, isWatchLater: true),
        Movie(title: "Fight Club", year: 1999, genre: "Drama", rating: 8.8, director: "David Fincher", duration: 139, description: "An insomniac office worker forms an underground fight club.", posterColor: .red, isWatchLater: false),
        Movie(title: "Goodfellas", year: 1990, genre: "Crime", rating: 8.7, director: "Martin Scorsese", duration: 146, description: "The story of Henry Hill's life in the mob from childhood to adulthood.", posterColor: .brown, isWatchLater: false),
        Movie(title: "The Shawshank Redemption", year: 1994, genre: "Drama", rating: 9.3, director: "Frank Darabont", duration: 142, description: "Two imprisoned men bond over years, finding solace through acts of decency.", posterColor: .gray, isWatchLater: true),
        Movie(title: "Forrest Gump", year: 1994, genre: "Drama", rating: 8.8, director: "Robert Zemeckis", duration: 142, description: "The presidencies of Kennedy and Johnson through the eyes of an Alabama man.", posterColor: .mint, isWatchLater: false),
        Movie(title: "The Godfather", year: 1972, genre: "Crime", rating: 9.2, director: "Francis Ford Coppola", duration: 175, description: "The aging patriarch transfers control of his empire to his reluctant son.", posterColor: .indigo, isWatchLater: false),
        Movie(title: "Schindler's List", year: 1993, genre: "Drama", rating: 9.0, director: "Steven Spielberg", duration: 195, description: "The story of how one man saved over a thousand Jewish lives during the Holocaust.", posterColor: .gray, isWatchLater: true),
        Movie(title: "Apocalypse Now", year: 1979, genre: "War", rating: 8.4, director: "Francis Ford Coppola", duration: 147, description: "A U.S. Army officer is sent to assassinate a colonel gone rogue in Vietnam.", posterColor: .green, isWatchLater: false)
    ]
}

// MARK: - Movie Catalog View

struct MovieCatalogExample: View {
    @State private var movies = Movie.sampleMovies
    @State private var searchText = ""
    @State private var selectedGenre = "All"
    @State private var sortBy: SortOption = .rating
    
    private let genres = ["All", "Action", "Crime", "Drama", "Sci-Fi", "Thriller", "War"]
    
    enum SortOption: String, CaseIterable {
        case title = "Title"
        case year = "Year"
        case rating = "Rating"
        case duration = "Duration"
    }
    
    private var filteredAndSortedMovies: [Movie] {
        var filtered = movies
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { movie in
                movie.title.localizedCaseInsensitiveContains(searchText) ||
                movie.director.localizedCaseInsensitiveContains(searchText) ||
                movie.genre.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by genre
        if selectedGenre != "All" {
            filtered = filtered.filter { $0.genre == selectedGenre }
        }
        
        // Sort
        return filtered.sorted { movie1, movie2 in
            switch sortBy {
            case .title:
                return movie1.title < movie2.title
            case .year:
                return movie1.year > movie2.year
            case .rating:
                return movie1.rating > movie2.rating
            case .duration:
                return movie1.duration > movie2.duration
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search and Filter Controls
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search movies, directors...", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        // Genre Filter
                        Picker("Genre", selection: $selectedGenre) {
                            ForEach(genres, id: \.self) { genre in
                                Text(genre).tag(genre)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Spacer()
                        
                        // Sort Options
                        Picker("Sort", selection: $sortBy) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                
                // Movie Grid
                GridNavigationView(
                    items: filteredAndSortedMovies,
                    columnCount: 4,
                    columnWidth: 180,
                    spacing: 16
                ) { movie in
                    MoviePosterCard(movie: movie) {
                        toggleWatchLater(for: movie)
                    }
                } detailContent: { movie in
                    MovieDetailView(movie: movie) {
                        toggleWatchLater(for: movie)
                    }
                }
            }
            .navigationTitle("Movie Catalog")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
    
    private func toggleWatchLater(for movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = Movie(
                title: movie.title,
                year: movie.year,
                genre: movie.genre,
                rating: movie.rating,
                director: movie.director,
                duration: movie.duration,
                description: movie.description,
                posterColor: movie.posterColor,
                isWatchLater: !movie.isWatchLater
            )
        }
    }
}

// MARK: - Movie Poster Card

struct MoviePosterCard: View {
    let movie: Movie
    let onWatchLaterToggle: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Movie Poster
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                movie.posterColor.opacity(0.8),
                                movie.posterColor.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 220)
                
                VStack {
                    Image(systemName: "film")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                    
                    if isHovered {
                        VStack(spacing: 4) {
                            Text("\(movie.duration) min")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.9))
                            
                            Button(action: onWatchLaterToggle) {
                                HStack(spacing: 4) {
                                    Image(systemName: movie.isWatchLater ? "bookmark.fill" : "bookmark")
                                    Text(movie.isWatchLater ? "Remove" : "Watch Later")
                                }
                                .font(.caption)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial, in: Capsule())
                            }
                        }
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                
                // Rating Badge
                VStack {
                    HStack {
                        Spacer()
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                            Text("\(movie.rating, specifier: "%.1f")")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(.black.opacity(0.6), in: Capsule())
                        .padding(.trailing, 8)
                        .padding(.top, 8)
                    }
                    Spacer()
                }
                
                // Watch Later Indicator
                if movie.isWatchLater {
                    VStack {
                        HStack {
                            Image(systemName: "bookmark.fill")
                                .font(.caption)
                                .foregroundStyle(.blue)
                                .padding(.leading, 8)
                                .padding(.top, 8)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hovering
                }
            }
            
            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
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
                
                Text("Dir. \(movie.director)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }
        }
        .frame(width: 160)
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Movie Detail View

struct MovieDetailView: View {
    let movie: Movie
    let onWatchLaterToggle: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    #if os(macOS)
    enum Field: Hashable { case title }
    @FocusState private var focusedField: Field?
    #endif
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with poster and main info
                HStack(alignment: .top, spacing: 20) {
                    // Poster
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    movie.posterColor.opacity(0.8),
                                    movie.posterColor.opacity(0.4)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 300)
                        .overlay(
                            Image(systemName: "film")
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                        )
                    
                    // Movie Information
                    VStack(alignment: .leading, spacing: 12) {
                        Text(movie.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            #if os(macOS)
                            .focusable()
                            .focused($focusedField, equals: .title)
                            #endif
                        
                        HStack {
                            // Rating
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                Text("\(movie.rating, specifier: "%.1f")/10")
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                            
                            // Watch Later Button
                            Button(action: onWatchLaterToggle) {
                                HStack(spacing: 6) {
                                    Image(systemName: movie.isWatchLater ? "bookmark.fill" : "bookmark")
                                    Text(movie.isWatchLater ? "Remove from Watch Later" : "Add to Watch Later")
                                }
                                .font(.subheadline)
                                .foregroundStyle(movie.isWatchLater ? .blue : .primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(movie.isWatchLater ? Color.blue : Color.primary.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        
                        // Movie Details Grid
                        VStack(alignment: .leading, spacing: 8) {
                            DetailRow(title: "Year", value: "\(movie.year)")
                            DetailRow(title: "Genre", value: movie.genre)
                            DetailRow(title: "Director", value: movie.director)
                            DetailRow(title: "Duration", value: "\(movie.duration) minutes")
                        }
                        
                        Spacer()
                    }
                }
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Synopsis")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(movie.description)
                        .font(.body)
                        .lineSpacing(4)
                }
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationTitle("Movie Details")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        #if os(macOS)
        .focusable()
        .onKeyPress(keys: [.escape]) { _ in
            dismiss()
            return .handled
        }
        .task(id: movie.id) {
            focusedField = nil
            await Task.yield()
            await Task.yield()
            focusedField = .title
        }
        #endif
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title + ":")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    MovieCatalogExample()
}