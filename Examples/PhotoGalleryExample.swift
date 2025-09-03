import SwiftUI
import GridNavigation

// MARK: - Photo Models

struct Photo: GridNavigable {
    let id = UUID()
    let filename: String
    let title: String
    let location: String?
    let dateCreated: Date
    let size: CGSize
    let tags: [String]
    let isFavorite: Bool
    let colorTheme: Color
    
    var sizeText: String {
        "\(Int(size.width)) × \(Int(size.height))"
    }
    
    var fileSizeText: String {
        let bytes = Int(size.width * size.height * 3) // Simulate RGB bytes
        if bytes < 1024 * 1024 {
            return "\(bytes / 1024) KB"
        } else {
            return String(format: "%.1f MB", Double(bytes) / (1024 * 1024))
        }
    }
    
    static let samplePhotos: [Photo] = [
        Photo(filename: "IMG_0001.jpg", title: "Golden Gate Bridge", location: "San Francisco, CA", dateCreated: Date().addingTimeInterval(-86400 * 30), size: CGSize(width: 3024, height: 4032), tags: ["landscape", "bridge", "architecture"], isFavorite: true, colorTheme: .orange),
        Photo(filename: "IMG_0002.jpg", title: "Mountain Sunrise", location: "Yosemite, CA", dateCreated: Date().addingTimeInterval(-86400 * 28), size: CGSize(width: 4032, height: 3024), tags: ["landscape", "mountains", "sunrise"], isFavorite: false, colorTheme: .pink),
        Photo(filename: "IMG_0003.jpg", title: "City Skyline", location: "New York, NY", dateCreated: Date().addingTimeInterval(-86400 * 25), size: CGSize(width: 2048, height: 1536), tags: ["city", "skyline", "urban"], isFavorite: true, colorTheme: .blue),
        Photo(filename: "IMG_0004.jpg", title: "Beach Sunset", location: "Malibu, CA", dateCreated: Date().addingTimeInterval(-86400 * 22), size: CGSize(width: 4032, height: 3024), tags: ["beach", "sunset", "ocean"], isFavorite: false, colorTheme: .orange),
        Photo(filename: "IMG_0005.jpg", title: "Forest Path", location: "Olympic National Park, WA", dateCreated: Date().addingTimeInterval(-86400 * 20), size: CGSize(width: 3024, height: 4032), tags: ["forest", "nature", "path"], isFavorite: true, colorTheme: .green),
        Photo(filename: "IMG_0006.jpg", title: "Desert Landscape", location: "Joshua Tree, CA", dateCreated: Date().addingTimeInterval(-86400 * 18), size: CGSize(width: 4032, height: 3024), tags: ["desert", "landscape", "rocks"], isFavorite: false, colorTheme: .brown),
        Photo(filename: "IMG_0007.jpg", title: "Lake Reflection", location: "Lake Tahoe, CA", dateCreated: Date().addingTimeInterval(-86400 * 15), size: CGSize(width: 3024, height: 4032), tags: ["lake", "reflection", "mountains"], isFavorite: true, colorTheme: .cyan),
        Photo(filename: "IMG_0008.jpg", title: "Urban Street Art", location: "Portland, OR", dateCreated: Date().addingTimeInterval(-86400 * 12), size: CGSize(width: 2048, height: 2048), tags: ["street art", "urban", "colorful"], isFavorite: false, colorTheme: .purple),
        Photo(filename: "IMG_0009.jpg", title: "Flower Garden", location: "Butchart Gardens, BC", dateCreated: Date().addingTimeInterval(-86400 * 10), size: CGSize(width: 4032, height: 3024), tags: ["flowers", "garden", "nature"], isFavorite: true, colorTheme: .pink),
        Photo(filename: "IMG_0010.jpg", title: "Snowy Mountain", location: "Whistler, BC", dateCreated: Date().addingTimeInterval(-86400 * 8), size: CGSize(width: 3024, height: 4032), tags: ["snow", "mountains", "winter"], isFavorite: false, colorTheme: .gray),
        Photo(filename: "IMG_0011.jpg", title: "Coastal Cliffs", location: "Big Sur, CA", dateCreated: Date().addingTimeInterval(-86400 * 5), size: CGSize(width: 4032, height: 3024), tags: ["coast", "cliffs", "ocean"], isFavorite: true, colorTheme: .blue),
        Photo(filename: "IMG_0012.jpg", title: "City Night", location: "Las Vegas, NV", dateCreated: Date().addingTimeInterval(-86400 * 3), size: CGSize(width: 2048, height: 1536), tags: ["city", "night", "lights"], isFavorite: false, colorTheme: .indigo),
        Photo(filename: "IMG_0013.jpg", title: "Autumn Forest", location: "Vermont", dateCreated: Date().addingTimeInterval(-86400 * 1), size: CGSize(width: 3024, height: 4032), tags: ["autumn", "forest", "colors"], isFavorite: true, colorTheme: .red),
        Photo(filename: "IMG_0014.jpg", title: "Waterfall", location: "Multnomah Falls, OR", dateCreated: Date(), size: CGSize(width: 4032, height: 3024), tags: ["waterfall", "nature", "rocks"], isFavorite: false, colorTheme: .mint)
    ]
}

// MARK: - Photo Gallery View

struct PhotoGalleryExample: View {
    @State private var photos = Photo.samplePhotos
    @State private var searchText = ""
    @State private var selectedTag = "All"
    @State private var showFavoritesOnly = false
    @State private var sortBy: SortOption = .dateCreated
    @State private var viewMode: ViewMode = .grid
    
    private var allTags: [String] {
        var tags = Set<String>()
        photos.forEach { tags.formUnion($0.tags) }
        return ["All"] + Array(tags).sorted()
    }
    
    enum SortOption: String, CaseIterable {
        case dateCreated = "Date Created"
        case filename = "Filename"
        case title = "Title"
        case fileSize = "File Size"
    }
    
    enum ViewMode: String, CaseIterable {
        case grid = "Grid"
        case list = "List"
    }
    
    private var filteredAndSortedPhotos: [Photo] {
        var filtered = photos
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { photo in
                photo.filename.localizedCaseInsensitiveContains(searchText) ||
                photo.title.localizedCaseInsensitiveContains(searchText) ||
                photo.location?.localizedCaseInsensitiveContains(searchText) == true ||
                photo.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Filter by tag
        if selectedTag != "All" {
            filtered = filtered.filter { $0.tags.contains(selectedTag) }
        }
        
        // Filter favorites
        if showFavoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        // Sort
        return filtered.sorted { photo1, photo2 in
            switch sortBy {
            case .dateCreated:
                return photo1.dateCreated > photo2.dateCreated
            case .filename:
                return photo1.filename < photo2.filename
            case .title:
                return photo1.title < photo2.title
            case .fileSize:
                return (photo1.size.width * photo1.size.height) > (photo2.size.width * photo2.size.height)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search and Filter Controls
                VStack(spacing: 12) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search photos, locations, tags...", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Filters Row 1
                    HStack {
                        // Tag Filter
                        Menu {
                            ForEach(allTags, id: \.self) { tag in
                                Button(tag) {
                                    selectedTag = tag
                                }
                            }
                        } label: {
                            HStack {
                                Text("Tag: \(selectedTag)")
                                Image(systemName: "chevron.down")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        
                        // Favorites Toggle
                        Button {
                            showFavoritesOnly.toggle()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                                Text("Favorites")
                            }
                            .font(.caption)
                            .foregroundStyle(showFavoritesOnly ? .red : .secondary)
                        }
                        
                        Spacer()
                        
                        // View Mode Toggle
                        Picker("View Mode", selection: $viewMode) {
                            ForEach(ViewMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 120)
                    }
                    
                    // Sort Options
                    HStack {
                        Text("Sort by:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Picker("Sort", selection: $sortBy) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Spacer()
                        
                        Text("\(filteredAndSortedPhotos.count) photos")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                
                // Photo Grid/List
                if viewMode == .grid {
                    GridNavigationView(
                        items: filteredAndSortedPhotos,
                        columnCount: 4,
                        columnWidth: 160,
                        spacing: 12
                    ) { photo in
                        PhotoThumbnailCard(photo: photo) {
                            toggleFavorite(for: photo)
                        }
                    } detailContent: { photo in
                        PhotoDetailView(photo: photo) {
                            toggleFavorite(for: photo)
                        }
                    }
                } else {
                    GridNavigationView(
                        items: filteredAndSortedPhotos,
                        columnCount: 1,
                        columnWidth: 600,
                        spacing: 8
                    ) { photo in
                        PhotoListRow(photo: photo) {
                            toggleFavorite(for: photo)
                        }
                    } detailContent: { photo in
                        PhotoDetailView(photo: photo) {
                            toggleFavorite(for: photo)
                        }
                    }
                }
            }
            .navigationTitle("Photo Gallery")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
    
    private func toggleFavorite(for photo: Photo) {
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            photos[index] = Photo(
                filename: photo.filename,
                title: photo.title,
                location: photo.location,
                dateCreated: photo.dateCreated,
                size: photo.size,
                tags: photo.tags,
                isFavorite: !photo.isFavorite,
                colorTheme: photo.colorTheme
            )
        }
    }
}

// MARK: - Photo Thumbnail Card

struct PhotoThumbnailCard: View {
    let photo: Photo
    let onFavoriteToggle: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 6) {
            // Photo Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [
                                photo.colorTheme.opacity(0.7),
                                photo.colorTheme.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
                
                // Photo Icon
                Image(systemName: "photo")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
                
                // Hover Overlay
                if isHovered {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.black.opacity(0.3))
                        .frame(height: 120)
                        .overlay(
                            VStack(spacing: 4) {
                                Text(photo.sizeText)
                                    .font(.caption2)
                                    .foregroundStyle(.white)
                                
                                Text(photo.fileSizeText)
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        )
                        .transition(.opacity)
                }
                
                // Favorite Heart
                VStack {
                    HStack {
                        Spacer()
                        Button(action: onFavoriteToggle) {
                            Image(systemName: photo.isFavorite ? "heart.fill" : "heart")
                                .font(.caption)
                                .foregroundStyle(photo.isFavorite ? .red : .white)
                                .padding(6)
                                .background(.black.opacity(0.4), in: Circle())
                        }
                        .padding(.trailing, 6)
                        .padding(.top, 6)
                    }
                    Spacer()
                }
            }
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hovering
                }
            }
            
            // Photo Info
            VStack(alignment: .leading, spacing: 2) {
                Text(photo.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                if let location = photo.location {
                    Text(location)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Text(photo.dateCreated.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 140)
        .padding(6)
    }
}

// MARK: - Photo List Row

struct PhotoListRow: View {
    let photo: Photo
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [
                            photo.colorTheme.opacity(0.7),
                            photo.colorTheme.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                )
            
            // Photo Details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(photo.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: onFavoriteToggle) {
                        Image(systemName: photo.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(photo.isFavorite ? .red : .secondary)
                    }
                }
                
                HStack {
                    Text(photo.filename)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if let location = photo.location {
                        Text("•")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(location)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                HStack {
                    Text(photo.sizeText)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    
                    Text(photo.fileSizeText)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    
                    Text(photo.dateCreated.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    
                    Spacer()
                }
                
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(photo.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(photo.colorTheme.opacity(0.2), in: Capsule())
                                .foregroundStyle(photo.colorTheme.opacity(0.8))
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Photo Detail View

struct PhotoDetailView: View {
    let photo: Photo
    let onFavoriteToggle: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Large Photo Display
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                photo.colorTheme.opacity(0.8),
                                photo.colorTheme.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 400)
                    .overlay(
                        VStack {
                            Image(systemName: "photo")
                                .font(.system(size: 80))
                                .foregroundStyle(.white)
                            
                            Text(photo.filename)
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding(.top, 8)
                        }
                    )
                    .overlay(
                        // Favorite Button Overlay
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: onFavoriteToggle) {
                                    Image(systemName: photo.isFavorite ? "heart.fill" : "heart")
                                        .font(.title3)
                                        .foregroundStyle(photo.isFavorite ? .red : .white)
                                        .padding(12)
                                        .background(.black.opacity(0.4), in: Circle())
                                }
                                .padding(.trailing, 16)
                                .padding(.top, 16)
                            }
                            Spacer()
                        }
                    )
                
                // Photo Information
                VStack(alignment: .leading, spacing: 16) {
                    Text(photo.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let location = photo.location {
                        HStack {
                            Image(systemName: "location")
                                .foregroundStyle(.secondary)
                            Text(location)
                                .font(.title3)
                        }
                    }
                    
                    // Photo Metadata
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Details")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        PhotoDetailRow(icon: "calendar", title: "Date Created", value: photo.dateCreated.formatted(date: .complete, time: .shortened))
                        PhotoDetailRow(icon: "rectangle", title: "Dimensions", value: photo.sizeText)
                        PhotoDetailRow(icon: "doc", title: "File Size", value: photo.fileSizeText)
                        PhotoDetailRow(icon: "textformat", title: "Filename", value: photo.filename)
                        
                        if photo.isFavorite {
                            PhotoDetailRow(icon: "heart.fill", title: "Status", value: "Favorite")
                        }
                    }
                    
                    // Tags
                    if !photo.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            FlowLayout(spacing: 6) {
                                ForEach(photo.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.subheadline)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(photo.colorTheme.opacity(0.2), in: Capsule())
                                        .foregroundStyle(photo.colorTheme.opacity(0.8))
                                }
                            }
                        }
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationTitle("Photo Details")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        #if os(macOS)
        .focusable()
        .onKeyPress(keys: [.escape]) { _ in
            dismiss()
            return .handled
        }
        #endif
    }
}

struct PhotoDetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)
            
            Text(title + ":")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
        }
    }
}

// MARK: - Flow Layout for Tags

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var height: CGFloat = 0
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentRowWidth + size.width > width && currentRowWidth > 0 {
                height += currentRowHeight + spacing
                currentRowWidth = size.width
                currentRowHeight = size.height
            } else {
                if currentRowWidth > 0 {
                    currentRowWidth += spacing
                }
                currentRowWidth += size.width
                currentRowHeight = max(currentRowHeight, size.height)
            }
        }
        
        height += currentRowHeight
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > bounds.maxX && currentX > bounds.minX {
                currentY += currentRowHeight + spacing
                currentX = bounds.minX
                currentRowHeight = 0
            }
            
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: ProposedViewSize(size))
            
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
    }
}

// MARK: - Preview

#Preview {
    PhotoGalleryExample()
}