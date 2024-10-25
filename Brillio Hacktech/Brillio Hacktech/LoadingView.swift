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
    @State private var hasLoaded = false // Track if the product data has already loaded
    let scannedCode: String

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    // Replace with your loading indicator
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
            .navigationDestination(isPresented: $showProduct) {
                if let product = productInfo {
                    ProductView(product: product)
                }
            }
        }
    }

    private func loadProductData() {
        // Prevent repeated loading for the same scanned code
        guard !hasLoaded else { return }

        guard let url = URL(string: "https://big-product-data.p.rapidapi.com/gtin/\(scannedCode)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Replace with your actual API key and host
        request.setValue("64e6766ee2msh186a35e81c043bdp12e2f2jsn8675b3d91c68", forHTTPHeaderField: "x-rapidapi-key")
        request.setValue("big-product-data.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Network Error: \(error.localizedDescription)")
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    self.isLoading = false
                    return
                }

                guard let data = data else {
                    print("Error: No data received")
                    self.errorMessage = "No data received from server"
                    self.isLoading = false
                    return
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                } else {
                    print("Response data is not in valid UTF-8 format")
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let product = try decoder.decode(ProductInfo.self, from: data)
                    self.productInfo = product
                    self.showProduct = true
                    self.hasLoaded = true // Mark as loaded to prevent re-triggering
                } catch {
                    print("General decoding error: \(error.localizedDescription)")
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }

                self.isLoading = false
            }
        }.resume()
    }
}
