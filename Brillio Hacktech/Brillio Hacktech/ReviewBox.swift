//
//  ReviewBox.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 26.10.2024.
//

import Foundation
import SwiftUI

struct ReviewBox: View {
    @State private var isExpanded: Bool = false
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Star Rating
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < review.rating ? "star.fill" : "star")
                            .foregroundColor(index < review.rating ? .yellow : .gray)
                    }
                }
                .accessibilityLabel("\(review.rating) out of 5 stars")
                
                Spacer()
            }
            
            // Review Title
            Text(review.title)
                .font(.headline)
                .padding(.top, 4)
            
            // Authenticity Score Progress Bar
            HStack {
                Text("Authenticity Score")
                    .font(.subheadline)
                Spacer()
                ThickProgressView(progress: review.authenticityScore)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 180)
            }
            .padding(.vertical, 4)
            
            // Review Content
            Text(review.content)
                .lineLimit(isExpanded ? nil : 3)
                .padding(.top, 4)
                .font(.body)
                .foregroundColor(.primary)
                .animation(.easeInOut, value: isExpanded)
            
            // Show More Button
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(isExpanded ? "Show Less" : "Show More")
                    .font(.subheadline)
                    .foregroundColor(.blueish)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        
        .shadow(radius: 4)
    }
}

struct ContentViewReviews: View {
    let reviews: [Review] = [
        Review(title: "Great Product", rating: 5, authenticityScore: 0.90, content: "This product exceeded my expectations. The quality is excellent and the support team was super helpful. Highly recommended for anyone looking for a reliable solution."),
        Review(title: "Not as Expected", rating: 2, authenticityScore: 0.59, content: "I found the product lacking in a few areas. It didn't perform as advertised and I was disappointed with the overall quality. However, customer service was decent.")
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(reviews) { review in
                ReviewBox(review: review)
            }
        }
        .padding()
        
    }
}

#Preview{
    ContentViewReviews()
}

