import GridNavigation
import SwiftUI

// MARK: - Product Models

enum ProductCategory: String, CaseIterable {
    case electronics = "Electronics"
    case clothing = "Clothing"
    case home = "Home & Garden"
    case books = "Books"
    case sports = "Sports"
    case toys = "Toys & Games"

    var icon: String {
        switch self {
        case .electronics: return "laptopcomputer"
        case .clothing: return "tshirt"
        case .home: return "house"
        case .books: return "book"
        case .sports: return "sportscourt"
        case .toys: return "gamecontroller"
        }
    }

    var color: Color {
        switch self {
        case .electronics: return .blue
        case .clothing: return .purple
        case .home: return .green
        case .books: return .orange
        case .sports: return .red
        case .toys: return .pink
        }
    }
}

enum ProductAvailability: String, CaseIterable {
    case inStock = "In Stock"
    case lowStock = "Low Stock"
    case outOfStock = "Out of Stock"
    case preOrder = "Pre-Order"

    var color: Color {
        switch self {
        case .inStock: return .green
        case .lowStock: return .orange
        case .outOfStock: return .red
        case .preOrder: return .blue
        }
    }

    var icon: String {
        switch self {
        case .inStock: return "checkmark.circle.fill"
        case .lowStock: return "exclamationmark.triangle.fill"
        case .outOfStock: return "xmark.circle.fill"
        case .preOrder: return "clock.circle.fill"
        }
    }
}

struct Product: GridNavigable {
    let id = UUID()
    let name: String
    let brand: String
    let price: Double
    let originalPrice: Double?
    let category: ProductCategory
    let availability: ProductAvailability
    let stockCount: Int
    let rating: Double
    let reviewCount: Int
    let description: String
    let features: [String]
    let isOnSale: Bool
    let isFeatured: Bool
    let imageColor: Color

    var discountPercentage: Int? {
        guard let originalPrice = originalPrice, originalPrice > price else {
            return nil
        }
        return Int(((originalPrice - price) / originalPrice) * 100)
    }

    var formattedPrice: String {
        String(format: "$%.2f", price)
    }

    var formattedOriginalPrice: String? {
        guard let originalPrice = originalPrice else { return nil }
        return String(format: "$%.2f", originalPrice)
    }

    static let sampleProducts: [Product] = [
        Product(
            name: "MacBook Pro 16\"",
            brand: "Apple",
            price: 2399.00,
            originalPrice: 2499.00,
            category: .electronics,
            availability: .inStock,
            stockCount: 15,
            rating: 4.8,
            reviewCount: 1247,
            description:
                "Professional laptop with M3 Pro chip, 16-inch Liquid Retina XDR display, and all-day battery life.",
            features: [
                "M3 Pro chip", "16-inch display", "18-hour battery",
                "96W USB-C adapter",
            ],
            isOnSale: true,
            isFeatured: true,
            imageColor: .gray
        ),

        Product(
            name: "Wireless Headphones",
            brand: "Sony",
            price: 199.99,
            originalPrice: nil,
            category: .electronics,
            availability: .inStock,
            stockCount: 45,
            rating: 4.5,
            reviewCount: 892,
            description:
                "Premium noise-canceling wireless headphones with 30-hour battery life.",
            features: [
                "Noise canceling", "30-hour battery", "Quick charge",
                "Touch controls",
            ],
            isOnSale: false,
            isFeatured: false,
            imageColor: .black
        ),

        Product(
            name: "Cotton T-Shirt",
            brand: "Uniqlo",
            price: 14.99,
            originalPrice: 19.99,
            category: .clothing,
            availability: .inStock,
            stockCount: 120,
            rating: 4.2,
            reviewCount: 456,
            description:
                "100% organic cotton t-shirt available in multiple colors and sizes.",
            features: [
                "100% cotton", "Machine washable", "Pre-shrunk",
                "Multiple colors",
            ],
            isOnSale: true,
            isFeatured: false,
            imageColor: .blue
        ),

        Product(
            name: "Gaming Chair",
            brand: "DXRacer",
            price: 299.99,
            originalPrice: 399.99,
            category: .home,
            availability: .lowStock,
            stockCount: 3,
            rating: 4.6,
            reviewCount: 234,
            description:
                "Ergonomic gaming chair with lumbar support and adjustable armrests.",
            features: [
                "Lumbar support", "Adjustable height", "360° swivel",
                "5-year warranty",
            ],
            isOnSale: true,
            isFeatured: true,
            imageColor: .red
        ),

        Product(
            name: "The Art of Programming",
            brand: "O'Reilly",
            price: 49.99,
            originalPrice: nil,
            category: .books,
            availability: .inStock,
            stockCount: 28,
            rating: 4.7,
            reviewCount: 567,
            description:
                "Comprehensive guide to modern programming techniques and best practices.",
            features: [
                "600+ pages", "Code examples", "Digital access",
                "Author interviews",
            ],
            isOnSale: false,
            isFeatured: false,
            imageColor: .orange
        ),

        Product(
            name: "Tennis Racket",
            brand: "Wilson",
            price: 159.99,
            originalPrice: 189.99,
            category: .sports,
            availability: .inStock,
            stockCount: 12,
            rating: 4.4,
            reviewCount: 189,
            description:
                "Professional tennis racket with power and control for intermediate players.",
            features: [
                "Power frame", "Comfort grip", "Vibration dampening",
                "String included",
            ],
            isOnSale: true,
            isFeatured: false,
            imageColor: .green
        ),

        Product(
            name: "LEGO Architecture Set",
            brand: "LEGO",
            price: 79.99,
            originalPrice: nil,
            category: .toys,
            availability: .preOrder,
            stockCount: 0,
            rating: 4.9,
            reviewCount: 123,
            description:
                "Build iconic landmarks with this detailed architecture set.",
            features: [
                "500+ pieces", "Display stand", "Instruction booklet",
                "Ages 12+",
            ],
            isOnSale: false,
            isFeatured: true,
            imageColor: .yellow
        ),

        Product(
            name: "Smart Watch",
            brand: "Garmin",
            price: 249.99,
            originalPrice: 299.99,
            category: .electronics,
            availability: .inStock,
            stockCount: 22,
            rating: 4.3,
            reviewCount: 678,
            description:
                "GPS smartwatch with health monitoring and 7-day battery life.",
            features: [
                "GPS tracking", "Heart rate monitor", "7-day battery",
                "Water resistant",
            ],
            isOnSale: true,
            isFeatured: false,
            imageColor: .mint
        ),

        Product(
            name: "Denim Jacket",
            brand: "Levi's",
            price: 89.99,
            originalPrice: 109.99,
            category: .clothing,
            availability: .lowStock,
            stockCount: 5,
            rating: 4.5,
            reviewCount: 345,
            description:
                "Classic denim jacket made from sustainable cotton with vintage wash.",
            features: [
                "Sustainable cotton", "Classic fit", "Multiple pockets",
                "Machine washable",
            ],
            isOnSale: true,
            isFeatured: false,
            imageColor: .indigo
        ),

        Product(
            name: "Robot Vacuum",
            brand: "iRobot",
            price: 399.99,
            originalPrice: 499.99,
            category: .home,
            availability: .inStock,
            stockCount: 18,
            rating: 4.6,
            reviewCount: 456,
            description:
                "Smart robot vacuum with app control and automatic dirt disposal.",
            features: [
                "App control", "Auto dirt disposal", "Smart mapping",
                "Voice control",
            ],
            isOnSale: true,
            isFeatured: true,
            imageColor: .gray
        ),

        Product(
            name: "Cookbook Collection",
            brand: "Williams Sonoma",
            price: 39.99,
            originalPrice: nil,
            category: .books,
            availability: .inStock,
            stockCount: 35,
            rating: 4.4,
            reviewCount: 234,
            description:
                "Professional chef cookbook with 200+ recipes and cooking techniques.",
            features: [
                "200+ recipes", "Step-by-step photos", "Cooking tips",
                "Hardcover",
            ],
            isOnSale: false,
            isFeatured: false,
            imageColor: .brown
        ),

        Product(
            name: "Basketball",
            brand: "Spalding",
            price: 24.99,
            originalPrice: 29.99,
            category: .sports,
            availability: .outOfStock,
            stockCount: 0,
            rating: 4.1,
            reviewCount: 167,
            description:
                "Official size basketball with excellent grip and durability.",
            features: [
                "Official size", "Composite leather", "Deep channels",
                "Indoor/outdoor",
            ],
            isOnSale: true,
            isFeatured: false,
            imageColor: .orange
        ),
    ]
}

// MARK: - Product Catalog View

struct ProductCatalogExample: View {
    @State private var products = Product.sampleProducts
    @State private var searchText = ""
    @State private var selectedCategory: ProductCategory? = nil
    @State private var selectedAvailability: ProductAvailability? = nil
    @State private var showOnSaleOnly = false
    @State private var showFeaturedOnly = false
    @State private var priceRange: ClosedRange<Double> = 0...500
    @State private var sortBy: SortOption = .featured
    @State private var viewMode: ViewMode = .grid

    enum SortOption: String, CaseIterable {
        case featured = "Featured"
        case priceLowToHigh = "Price: Low to High"
        case priceHighToLow = "Price: High to Low"
        case rating = "Customer Rating"
        case name = "Name A-Z"
        case newest = "Newest"
    }

    enum ViewMode: String, CaseIterable {
        case grid = "Grid"
        case list = "List"
    }

    private var filteredAndSortedProducts: [Product] {
        var filtered = products

        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText)
                    || product.brand.localizedCaseInsensitiveContains(
                        searchText
                    )
                    || product.description.localizedCaseInsensitiveContains(
                        searchText
                    )
                    || product.features.contains {
                        $0.localizedCaseInsensitiveContains(searchText)
                    }
            }
        }

        // Filter by category
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }

        // Filter by availability
        if let availability = selectedAvailability {
            filtered = filtered.filter { $0.availability == availability }
        }

        // Filter by sale status
        if showOnSaleOnly {
            filtered = filtered.filter { $0.isOnSale }
        }

        // Filter by featured status
        if showFeaturedOnly {
            filtered = filtered.filter { $0.isFeatured }
        }

        // Filter by price range
        filtered = filtered.filter { priceRange.contains($0.price) }

        // Sort
        return filtered.sorted { product1, product2 in
            switch sortBy {
            case .featured:
                if product1.isFeatured != product2.isFeatured {
                    return product1.isFeatured && !product2.isFeatured
                }
                return product1.rating > product2.rating
            case .priceLowToHigh:
                return product1.price < product2.price
            case .priceHighToLow:
                return product1.price > product2.price
            case .rating:
                return product1.rating > product2.rating
            case .name:
                return product1.name < product2.name
            case .newest:
                return product1.id.uuidString < product2.id.uuidString  // Simulate newness
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchAndFilterControls
                productView
            }
            .navigationTitle("Product Catalog")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }

    @ViewBuilder
    private var searchAndFilterControls: some View {
        VStack(spacing: 12) {
            searchBar
            filterControlsRow
            sortAndViewControls
        }
        .padding()
        .background(.ultraThinMaterial)
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search products, brands, features...", text: $searchText)
                .textFieldStyle(.roundedBorder)
        }
    }

    private var filterControlsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                categoryFilterMenu
                availabilityFilterMenu
                onSaleToggle
                featuredToggle
            }
            .padding(.horizontal)
        }
    }

    private var categoryFilterMenu: some View {
        Menu {
            Button("All Categories") {
                selectedCategory = nil
            }
            ForEach(ProductCategory.allCases, id: \.self) { category in
                Button {
                    selectedCategory = category
                } label: {
                    HStack {
                        Image(systemName: category.icon)
                        Text(category.rawValue)
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: selectedCategory?.icon ?? "square.grid.2x2")
                Text(selectedCategory?.rawValue ?? "All Categories")
                Image(systemName: "chevron.down")
            }
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())
        }
    }

    private var availabilityFilterMenu: some View {
        Menu {
            Button("All Availability") {
                selectedAvailability = nil
            }
            ForEach(ProductAvailability.allCases, id: \.self) { availability in
                Button {
                    selectedAvailability = availability
                } label: {
                    HStack {
                        Image(systemName: availability.icon)
                            .foregroundStyle(availability.color)
                        Text(availability.rawValue)
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: selectedAvailability?.icon ?? "circle")
                Text(selectedAvailability?.rawValue ?? "All")
                Image(systemName: "chevron.down")
            }
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())
        }
    }

@ViewBuilder
    private var onSaleToggle: some View {
        Button {
            showOnSaleOnly.toggle()
        } label: {
            let baseView = HStack(spacing: 4) {
                Image(systemName: "tag.fill")
                Text("On Sale")
            }
            .font(.caption)
            .foregroundStyle(showOnSaleOnly ? .white : .primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            
            if showOnSaleOnly {
                baseView
                    .background(Color.red, in: Capsule())
            } else {
                baseView
                    .background(.ultraThinMaterial, in: Capsule())
            }
        }
    }

@ViewBuilder
    private var featuredToggle: some View {
        Button {
            showFeaturedOnly.toggle()
        } label: {
            let baseView = HStack(spacing: 4) {
                Image(systemName: "star.fill")
                Text("Featured")
            }
            .font(.caption)
            .foregroundStyle(showFeaturedOnly ? .white : .primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            
            if showFeaturedOnly {
                baseView
                    .background(Color.blue, in: Capsule())
            } else {
                baseView
                    .background(.ultraThinMaterial, in: Capsule())
            }
        }
    }

    private var sortAndViewControls: some View {
        HStack {
            // Sort Options
            Picker("Sort", selection: $sortBy) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)

            Spacer()

            // Results Count
            Text("\(filteredAndSortedProducts.count) products")
                .font(.caption)
                .foregroundStyle(.secondary)

            // View Mode Toggle
            Picker("View Mode", selection: $viewMode) {
                ForEach(ViewMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 120)
        }
    }

    @ViewBuilder
    private var productView: some View {
        if viewMode == .grid {
            GridNavigationView(
                items: filteredAndSortedProducts,
                columnCount: 3,
                columnWidth: 220,
                spacing: 16
            ) { product in
                ProductCard(product: product)
            } detailContent: { product in
                ProductDetailView(product: product)
            }
        } else {
            GridNavigationView(
                items: filteredAndSortedProducts,
                columnCount: 1,
                columnWidth: 700,
                spacing: 8
            ) { product in
                ProductListRow(product: product)
            } detailContent: { product in
                ProductDetailView(product: product)
            }
        }
    }
}

// MARK: - Product Card

struct ProductCard: View {
    let product: Product
    @State private var isHovered = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Product Image
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                product.imageColor.opacity(0.7),
                                product.imageColor.opacity(0.3),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 160)

                Image(systemName: product.category.icon)
                    .font(.system(size: 40))
                    .foregroundStyle(.white)

                // Badges Overlay
                VStack {
                    HStack {
                        // Featured Badge
                        if product.isFeatured {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                Text("Featured")
                            }
                            .font(.caption2)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.blue, in: Capsule())
                        }

                        Spacer()

                        // Sale Badge
                        if product.isOnSale,
                            let discount = product.discountPercentage
                        {
                            Text("-\(discount)%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.red, in: Capsule())
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 8)

                    Spacer()

                    // Availability Status
                    HStack {
                        Spacer()
                        HStack(spacing: 2) {
                            Image(systemName: product.availability.icon)
                            Text(product.availability.rawValue)
                        }
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(product.availability.color, in: Capsule())
                    }
                    .padding(.bottom, 8)
                    .padding(.horizontal, 8)
                }

                // Hover Actions
                if isHovered && product.availability != .outOfStock {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.black.opacity(0.4))
                        .frame(height: 160)
                        .overlay(
                            VStack(spacing: 8) {
                                Button("Quick View") {
                                    // Quick view action
                                }
                                .font(.caption)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.white.opacity(0.2), in: Capsule())

                                if product.availability == .inStock {
                                    Button("Add to Cart") {
                                        // Add to cart action
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.white, in: Capsule())
                                }
                            }
                        )
                        .transition(.opacity)
                }
            }
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hovering
                }
            }

            // Product Information
            VStack(alignment: .leading, spacing: 6) {
                Text(product.brand)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                // Rating
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(
                            systemName: index < Int(product.rating)
                                ? "star.fill" : "star"
                        )
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    }
                    Text("(\(product.reviewCount))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                // Price
                HStack(alignment: .bottom) {
                    Text(product.formattedPrice)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    if let originalPrice = product.formattedOriginalPrice {
                        Text(originalPrice)
                            .font(.caption)
                            .strikethrough()
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
            }
        }
        .frame(width: 200)
        .padding(12)
        .background(Color.clear, in: RoundedRectangle(cornerRadius: 16))
        .background(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Product List Row

struct ProductListRow: View {
    let product: Product

    var body: some View {
        HStack(spacing: 16) {
            // Product Image
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [
                                product.imageColor.opacity(0.7),
                                product.imageColor.opacity(0.3),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)

                Image(systemName: product.category.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(.white)

                // Sale Badge
                if product.isOnSale, let discount = product.discountPercentage {
                    VStack {
                        HStack {
                            Spacer()
                            Text("-\(discount)%")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(.red, in: Capsule())
                        }
                        Spacer()
                    }
                    .padding(4)
                }
            }

            // Product Details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(product.brand)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(product.name)
                            .font(.headline)
                            .lineLimit(1)
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        if product.isFeatured {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                Text("Featured")
                            }
                            .font(.caption2)
                            .foregroundStyle(.blue)
                        }

                        HStack(spacing: 2) {
                            Image(systemName: product.availability.icon)
                                .foregroundStyle(product.availability.color)
                            Text(product.availability.rawValue)
                        }
                        .font(.caption2)
                    }
                }

                // Rating and Reviews
                HStack(spacing: 4) {
                    HStack(spacing: 1) {
                        ForEach(0..<5) { index in
                            Image(
                                systemName: index < Int(product.rating)
                                    ? "star.fill" : "star"
                            )
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                        }
                    }
                    Text(
                        "\(product.rating, specifier: "%.1f") (\(product.reviewCount) reviews)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Spacer()
                }

                // Price
                HStack {
                    Text(product.formattedPrice)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    if let originalPrice = product.formattedOriginalPrice {
                        Text(originalPrice)
                            .font(.subheadline)
                            .strikethrough()
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if product.availability == .inStock {
                        Button("Add to Cart") {
                            // Add to cart action
                        }
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.blue, in: Capsule())
                    }
                }
            }
            .padding(12)
            .background(Color.clear, in: RoundedRectangle(cornerRadius: 12))
            .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Product Detail View

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss

    #if os(macOS)
        enum Field: Hashable { case name }
        @FocusState private var focusedField: Field?
    #endif

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Product Image and Basic Info
                HStack(alignment: .top, spacing: 24) {
                    // Large Product Image
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        product.imageColor.opacity(0.8),
                                        product.imageColor.opacity(0.4),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 300, height: 300)

                        Image(systemName: product.category.icon)
                            .font(.system(size: 80))
                            .foregroundStyle(.white)

                        // Badges
                        VStack {
                            HStack {
                                if product.isFeatured {
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                        Text("Featured")
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.blue, in: Capsule())
                                }

                                Spacer()

                                if product.isOnSale,
                                    let discount = product.discountPercentage
                                {
                                    Text("-\(discount)% OFF")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(.red, in: Capsule())
                                }
                            }
                            .padding(.top, 12)
                            .padding(.horizontal, 12)

                            Spacer()
                        }
                    }

                    // Product Information
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(product.brand)
                                .font(.title3)
                                .foregroundStyle(.secondary)

                            Text(product.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                #if os(macOS)
                                    .focusable()
                                    .focused($focusedField, equals: .name)
                                #endif
                        }

                        // Rating and Reviews
                        HStack(spacing: 8) {
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(
                                        systemName: index < Int(product.rating)
                                            ? "star.fill" : "star"
                                    )
                                    .font(.subheadline)
                                    .foregroundStyle(.yellow)
                                }
                            }
                            Text("\(product.rating, specifier: "%.1f")")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("(\(product.reviewCount) reviews)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        // Price
                        HStack(alignment: .bottom) {
                            Text(product.formattedPrice)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)

                            if let originalPrice = product
                                .formattedOriginalPrice
                            {
                                Text(originalPrice)
                                    .font(.title3)
                                    .strikethrough()
                                    .foregroundStyle(.secondary)
                            }
                        }

                        // Availability
                        HStack(spacing: 8) {
                            Image(systemName: product.availability.icon)
                                .foregroundStyle(product.availability.color)
                            Text(product.availability.rawValue)
                                .fontWeight(.medium)
                                .foregroundStyle(product.availability.color)

                            if product.availability == .lowStock {
                                Text("Only \(product.stockCount) left")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        // Action Buttons
                        VStack(spacing: 12) {
                            if product.availability != .outOfStock {
                                Button {
                                    // Add to cart action
                                } label: {
                                    HStack {
                                        Image(systemName: "cart.badge.plus")
                                        Text(
                                            product.availability == .preOrder
                                                ? "Pre-Order Now"
                                                : "Add to Cart"
                                        )
                                    }
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        .blue,
                                        in: RoundedRectangle(cornerRadius: 12)
                                    )
                                }
                            }

                            Button {
                                // Add to wishlist action
                            } label: {
                                HStack {
                                    Image(systemName: "heart")
                                    Text("Add to Wishlist")
                                }
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            Color.primary.opacity(0.3),
                                            lineWidth: 1
                                        )
                                )
                            }
                        }

                        Spacer()
                    }
                }

                // Product Description
                VStack(alignment: .leading, spacing: 12) {
                    Text("Description")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(product.description)
                        .font(.body)
                        .lineSpacing(4)
                }

                // Features
                VStack(alignment: .leading, spacing: 12) {
                    Text("Features")
                        .font(.title2)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(product.features, id: \.self) { feature in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text(feature)
                                    .font(.subheadline)
                                Spacer()
                            }
                        }
                    }
                }

                // Category and Additional Info
                VStack(alignment: .leading, spacing: 12) {
                    Text("Product Details")
                        .font(.title2)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading, spacing: 8) {
                        ProductDetailRow(
                            title: "Category",
                            value: product.category.rawValue,
                            icon: product.category.icon
                        )
                        ProductDetailRow(
                            title: "Brand",
                            value: product.brand,
                            icon: "building.2"
                        )
                        ProductDetailRow(
                            title: "Availability",
                            value: product.availability.rawValue,
                            icon: product.availability.icon
                        )
                        if product.availability != .outOfStock
                            && product.availability != .preOrder
                        {
                            ProductDetailRow(
                                title: "Stock",
                                value: "\(product.stockCount) available",
                                icon: "cube.box"
                            )
                        }
                    }
                }

                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationTitle("Product Details")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        #if os(macOS)
            .focusable()
            .onKeyPress(keys: [.escape]) { _ in
                dismiss()
                return .handled
            }
            .task(id: product.id) {
                focusedField = nil
                await Task.yield()
                await Task.yield()
                focusedField = .name
            }
        #endif
    }
}

struct ProductDetailRow: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)

            Text(title + ":")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 100, alignment: .leading)

            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    ProductCatalogExample()
}
