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
    let description: [String]? // Flexible handling of `description`
    let brand: String?
    let manufacturer: String?
    let mpn: String?
    let features: [String]?
    let itemWeight: String?
    let partNumber: String?
    let size: String?
    let ingredients: String?
    let directions: String?
    let warning: String?
    let label: String?
    let distributorAddress: String?
    let distributorName: String?
    let gender: String?
    let formulation: String?
    let usage: String?
    let spf: String?
    let volume: String?
    let color: String?
    let material: String?
    let model: String?
    let age: String?
    
    enum CodingKeys: String, CodingKey {
        case title, description, brand, manufacturer, mpn, features
        case itemWeight = "item weight"
        case partNumber = "part number"
        case size, ingredients, directions, warning
        case label
        case distributorAddress = "distributor address"
        case distributorName = "distributor name"
        case gender, formulation, usage, spf, volume
        case color, material, model, age
    }
    
    // Custom initializer to handle both single String and [String] cases for `description`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode([String].self, forKey: .title)
        
        // Decode `description` as either [String] or a single String
        if let descriptionArray = try? container.decode([String].self, forKey: .description) {
            description = descriptionArray
        } else if let descriptionString = try? container.decode(String.self, forKey: .description) {
            description = [descriptionString]
        } else {
            description = nil
        }
        
        // Decode other properties normally
        brand = try? container.decode(String.self, forKey: .brand)
        manufacturer = try? container.decode(String.self, forKey: .manufacturer)
        mpn = try? container.decode(String.self, forKey: .mpn)
        features = try? container.decode([String].self, forKey: .features)
        itemWeight = try? container.decode(String.self, forKey: .itemWeight)
        partNumber = try? container.decode(String.self, forKey: .partNumber)
        size = try? container.decode(String.self, forKey: .size)
        ingredients = try? container.decode(String.self, forKey: .ingredients)
        directions = try? container.decode(String.self, forKey: .directions)
        warning = try? container.decode(String.self, forKey: .warning)
        label = try? container.decode(String.self, forKey: .label)
        distributorAddress = try? container.decode(String.self, forKey: .distributorAddress)
        distributorName = try? container.decode(String.self, forKey: .distributorName)
        gender = try? container.decode(String.self, forKey: .gender)
        formulation = try? container.decode(String.self, forKey: .formulation)
        usage = try? container.decode(String.self, forKey: .usage)
        spf = try? container.decode(String.self, forKey: .spf)
        volume = try? container.decode(String.self, forKey: .volume)
        color = try? container.decode(String.self, forKey: .color)
        material = try? container.decode(String.self, forKey: .material)
        model = try? container.decode(String.self, forKey: .model)
        age = try? container.decode(String.self, forKey: .age)
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        list = try? container.decode(String.self, forKey: .list) ??
               (try? String(container.decode(Double.self, forKey: .list)))
        
        sale = try? container.decode(String.self, forKey: .sale) ??
               (try? String(container.decode(Double.self, forKey: .sale)))
        
        price = try? container.decode(String.self, forKey: .price) ??
                (try? String(container.decode(Double.self, forKey: .price)))
        
        currency = try? container.decode(String.self, forKey: .currency)
        perUnit = try? container.decode(String.self, forKey: .perUnit)
    }
    
    init(list: String?, sale: String?, currency: String?, perUnit: String?, price: String?) {
        self.list = list
        self.sale = sale
        self.currency = currency
        self.perUnit = perUnit
        self.price = price
    }
}
