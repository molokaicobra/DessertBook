//
//  Caching.swift
//  DessertBook
//
//  Created by Cobra Curtis on 6/20/24.
//

import SwiftUI

// A singleton class that handles image caching and downloading.
class ImageCache: ObservableObject {
    // Shared instance of `ImageCache`.
    static let shared = ImageCache()
    
    // Internal cache to store images.
    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession
    
    // Private initializer to enforce singleton pattern.
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0 // 30 seconds timeout
        configuration.timeoutIntervalForResource = 60.0 // 60 seconds timeout
        self.session = URLSession(configuration: configuration)
    }
    
    /**
     Attempts to get an image from the shared ImageCache. If the image is in the cache we use completion handling to return the Image.
     If the image is not in the cache the method then calls `downloadImage()`.  If that returns successfully it then the image is assigned to the cache.
     
     - Parameters:
        - url: The URL of the image to retrieve.
        - compressionQuality: The quality of the JPEG compression (default is 0.4).
     - Returns: The cached or downloaded `UIImage`, or `nil` if the download fails.
     */
    func getImage(for url: URL, compressionQuality: CGFloat = 0.4) async -> UIImage? {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        } else {
            return await downloadImage(from: url, compressionQuality: compressionQuality)
        }
    }
    
    /**
     Downloads an image from a given URL and compresses it.
     
     - Parameters:
        - url: The URL to download the image from.
        - compressionQuality: The quality of the JPEG compression (default is 0.4).
     - Returns: The downloaded and compressed `UIImage`, or `nil` if the download fails.
     */
    private func downloadImage(from url: URL, compressionQuality: CGFloat) async -> UIImage? {
        do {
            let (data, _) = try await session.data(from: url)
            guard var image = UIImage(data: data) else { return nil }
            
            if let compressedData = image.jpegData(compressionQuality: compressionQuality) {
                image = UIImage(data: compressedData) ?? image
            }
            
            cache.setObject(image, forKey: url.absoluteString as NSString)
            return image
        } catch {
            print("Failed to download image: \(error)")
            return nil
        }
    }
}

// A view that asynchronously loads and displays an image, using a placeholder until the image is available.
struct CachedAsyncImage<Content: View>: View {
    @StateObject private var loader: ImageLoader
    private let content: (Image?) -> Content
    private let placeholder: Image
    
    /**
     Initializes a new `CachedAsyncImage` view. This is used to display a place holder image. It then calls 'ImageLoader' to attempt to cache and retrieve the image.
     
     - Parameters:
        - url: The URL of the image to load.
        - placeholder: The placeholder image to display while the image is loading (default is a system photo icon).
        - content: A view builder that creates a view to display the image.
     */
    init(url: URL, placeholder: Image = Image(systemName: "photo"), @ViewBuilder content: @escaping (Image?) -> Content) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
        self.content = content
    }
    
    var body: some View {
        content(loader.image.map(Image.init) ?? placeholder)
            .onAppear {
                loader.load()
            }
    }
}

// A class responsible for loading an image from a URL and retreiving it from the cache
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    
    /**
     Initializes a new `ImageLoader` with the given URL.
     
     - Parameter url: The URL of the image to load. This will also be used as the key for the cache.
     */
    init(url: URL) {
        self.url = url
    }
    
    /**
     Loads the image from the URL using `ImageCache` and updates the published `image` property.
     
     - Throws: An error if the image loading fails.
     */
    @MainActor
    func load() {
        Task {
            self.image = await ImageCache.shared.getImage(for: url)
        }
    }
}
