//
//  LoadingView.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 25.10.2024.
//

import SwiftUI
import Lottie
import Foundation

struct LoadingView: View {
    @State private var productInfo: ProductInfo?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showProduct = false
    @State private var hasLoaded = false // Track if product data has loaded
    @State private var reviews: [Review]? // Holds fetched reviews
    let scannedCode: String

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    LottieView(name: "loading", loopMode: .loop)
                        .frame(width: 200, height: 200)
                        .scaleEffect(2)
                } else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .onAppear(perform: loadProductData)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: customBackButton)
            .navigationDestination(isPresented: $showProduct) {
                if let product = productInfo, let review = reviews {
                    ProductView(product: product, reviews: review)
                }
            }
        }
    }

    private var customBackButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.blueish)
        }
    }
    
    private func loadProductData() {
        guard !hasLoaded else { return }
        guard let url = URL(string: "https://big-product-data.p.rapidapi.com/gtin/\(scannedCode)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("928c1149famsh602b67cfa1f7304p1b9c0cjsn85600746979e", forHTTPHeaderField: "x-rapidapi-key")
        request.setValue("big-product-data.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    self.isLoading = false
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received from server"
                    self.isLoading = false
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let product = try decoder.decode(ProductInfo.self, from: data)
                    self.productInfo = product
                    
                    
                    if let asin = product.stores.first?.asin, let country = getCountryCode(for: product.stores.first?.store) {
                        fetchProductReviews(asin: asin, country: country)
                    }
                } catch {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
                self.isLoading = false
            }
        }.resume()
    }

    private func getCountryCode(for store: String?) -> String? {
        guard let store = store else { return nil }
        switch store {
        case "Amazon US": return "US"
        case "Amazon UK": return "GB"
        case "Amazon DE": return "DE"
        case "Amazon FR": return "FR"
        // Add more mappings as needed
        default: return nil
        }
    }
    
    private func fetchProductReviews(asin: String, country: String) {
        if reviews != nil {
            print("Reviews already loaded. Skipping fetch for other countries.")
            return
        }

        guard let url = URL(string: "https://real-time-amazon-data.p.rapidapi.com/product-reviews?asin=\(asin)&country=\(country)&sort_by=TOP_REVIEWS&star_rating=ALL&verified_purchases_only=true&images_or_videos_only=false&current_format_only=false&page=1") else {
            errorMessage = "Invalid Review URL"
            print("Error: Invalid Review URL for ASIN \(asin) and country \(country)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("928c1149famsh602b67cfa1f7304p1b9c0cjsn85600746979e", forHTTPHeaderField: "x-rapidapi-key")
        request.setValue("real-time-amazon-data.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Review fetch error: \(error.localizedDescription)"
                    print("Network error occurred: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No review data received from server"
                    print("Error: No data received for reviews request.")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let reviewResponse = try decoder.decode(ReviewResponse.self, from: data)
                    self.reviews = reviewResponse.data.reviews
                    print("Successfully decoded reviews for ASIN \(asin).")
                    self.showProduct = true
                    self.hasLoaded = true
                } catch {
                    self.errorMessage = "Review decoding error: \(error.localizedDescription)"
                    print("Decoding error: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Failed JSON: \(jsonString)")
                    }
                }
            }
        }.resume()
    }

}
