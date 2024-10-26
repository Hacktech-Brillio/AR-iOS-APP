//
//  Data.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 25.10.2024.
//

import Foundation

struct ProductInfo: Codable {
    let gtin: String
    let properties: ProductProperties
    let stores: [StoreInfo]
}

struct ProductProperties: Codable {
    let title: [String]
    let description: [String]?
    let brand: String? // Updated to String to handle single brand name
    let manufacturer: String? // Updated to String for single manufacturer name
    let mpn: String? // Updated to single String type
    let features: [String]?
    let itemWeight: String?
    let partNumber: String?
    let size: String?
    let ingredients: String?
    let directions: String?
    let warning: String?
    
    // Additional fields based on JSON response
    let label: String?
    let distributorAddress: String?
    let distributorName: String?
    let gender: String?
    let formulation: String?
    let usage: String?
    let spf: String?
    let volume: String?

    // Map JSON keys that use different naming conventions
    enum CodingKeys: String, CodingKey {
        case title, description, brand, manufacturer, mpn, features
        case itemWeight = "item weight"
        case partNumber = "part number"
        case size, ingredients, directions, warning
        case label
        case distributorAddress = "distributor address"
        case distributorName = "distributor name"
        case gender, formulation, usage, spf, volume
    }
}

struct StoreInfo: Codable, Identifiable {
    let id = UUID()
    let store: String
    let image: String?
    let url: String
    let categories: [String]?
    let price: Price?
    let asin: String?
    let sku: String?
    
    enum CodingKeys: String, CodingKey {
        case store, image, url, categories, price, asin, sku
    }
}

struct Price: Codable {
    let list: String?
    let sale: String?
    let currency: String?
    let perUnit: String?
    let price: String?
    
    enum CodingKeys: String, CodingKey {
        case list, sale, currency
        case perUnit = "per unit"
        case price
    }
    
    // Custom decoding initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode as String, falling back to Double if String fails
        list = try? container.decode(String.self, forKey: .list) ??
               (try? String(container.decode(Double.self, forKey: .list)))
        
        sale = try? container.decode(String.self, forKey: .sale) ??
               (try? String(container.decode(Double.self, forKey: .sale)))
        
        price = try? container.decode(String.self, forKey: .price) ??
                (try? String(container.decode(Double.self, forKey: .price)))
        
        currency = try? container.decode(String.self, forKey: .currency)
        perUnit = try? container.decode(String.self, forKey: .perUnit)
    }
    
    // Custom memberwise initializer
    init(list: String?, sale: String?, currency: String?, perUnit: String?, price: String?) {
        self.list = list
        self.sale = sale
        self.currency = currency
        self.perUnit = perUnit
        self.price = price
    }
}
