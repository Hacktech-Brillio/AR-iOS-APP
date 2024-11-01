//
//  AuthorizedAsyncImage.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 25.10.2024.
//

import Combine
import Foundation
import UIKit
import SwiftUI

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var currentIndex = 0
    private var urls: [URL] = []
    
    func loadImages(from urls: [String]) {
        self.urls = urls.compactMap { URL(string: $0) }
        currentIndex = 0
        loadImage()
    }
    
    private func loadImage() {
        guard currentIndex < urls.count else { return } // Stop if no more images
        
        let url = urls[currentIndex]
        let cacheKey = NSString(string: url.absoluteString)

        if let cachedImage = ImageCache.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data,
                  let uiImage = UIImage(data: data) else {
                self.currentIndex += 1 // Move to the next URL
                self.loadImage() // Attempt loading the next image
                return
            }

            ImageCache.shared.setObject(uiImage, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = uiImage
            }
        }.resume()
    }
}

struct AuthorizedAsyncImage: View {
    let urls: [String]
    @StateObject private var loader = ImageLoader()
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .onAppear {
                        loader.loadImages(from: urls)
                    }
            }
        }
    }
}
