//
//  Review.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 26.10.2024.
//

import Foundation

struct Review: Identifiable {
    let id = UUID()
    let title: String
    let rating: Int
    let authenticityScore: Double // Value between 0.0 and 1.0
    let content: String
}

