//
//  ReviewBox.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 26.10.2024.
//

import Foundation
import SwiftUI
import CoreML

struct ReviewBox: View {
    @State private var isExpanded: Bool = false
    let review: Review
    @State private var credibilityScore: Double? = nil
    @State private var predictionResult: String = "Calculating..."

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Star Rating
                HStack(spacing: 4) {
                    if let starRating = Int(review.starRating) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < starRating ? "star.fill" : "star")
                                .foregroundColor(index < starRating ? .yellow : .gray)
                        }
                    }
                }
                
                Spacer()
            }
            
            // Review Title
            HStack{
                Text(review.title)
                    .font(.headline)
                    .padding(.top, 4)
                
            }
            
            // Credibility Score Progress Bar
            HStack {
                Text("Credibility Score")
                    .font(.subheadline)
                Spacer()
                if let score = credibilityScore {
                    ThickProgressView(progress: score)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(width: 180)
                }
            }
            .padding(.vertical, 4)
            
            // Review Content
            Text(review.comment)
                //.lineLimit(isExpanded ? nil : 3)
                .padding(.top, 4)
                .font(.body)
                .foregroundColor(.primary)
                .animation(.easeInOut, value: isExpanded)
            
            // Show More Button
//            Button(action: {
//                withAnimation {
//                    isExpanded.toggle()
//                }
//            }) {
//                Text(isExpanded ? "Show Less" : "Show More")
//                    .font(.subheadline)
//                    .foregroundColor(.blue)
//                    .padding(.top, 4)
//            }
            Text(review.reviewDate)
                .font(.caption)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .onAppear {
            Task {
                await classifyReview()
            }
        }
    }

    // Function to classify review and set credibility score
    func classifyReview() async {
        // Step 1: Load the model
        guard let model = await loadModel() else {
            print("Debug: Model loading failed.")
            predictionResult = "Model loading failed."
            return
        }
        print("Debug: Model loaded successfully.")

        // Step 2: Preprocess the review text
        let processedInput = preprocessText(review.comment)
        print("Debug: Processed Input (Tokenized Text): \(processedInput)")

        do {
            // Step 3: Pad or truncate input to match model's sequence length
            let maxSeqLength = 100 // Adjust based on your model's sequence length
            let paddedInput = padOrTruncate(sequence: processedInput, toLength: maxSeqLength)
            print("Debug: Padded Input: \(paddedInput)")

            // Step 4: Convert input to MLMultiArray format
            let inputArray = try MLMultiArray(shape: [1, NSNumber(value: maxSeqLength)], dataType: .int32)
            
            for (index, value) in paddedInput.enumerated() {
                inputArray[[0, index] as [NSNumber]] = NSNumber(value: value)
            }
            print("Debug: MLMultiArray Input Array: \(inputArray)")

            // Step 5: Create input and get the prediction
            let input = FakeReviewClassifier_with_labelsInput(input: inputArray)
            let output = try await model.prediction(input: input)

            // Step 6: Retrieve raw class probabilities
            let classProbs = output.classLabel_probs
            print("Debug: Raw Class Probabilities: \(classProbs)")

            // Step 7: Normalize probabilities if needed
            let totalProb = classProbs.values.reduce(0.0, +)
            
            // Apply softmax if the total probability is not approximately 1
            var normalizedProbs: [String: Double]
            if abs(totalProb - 1.0) > 0.01 {
                // Softmax Transformation
                let expValues = classProbs.mapValues { exp($0) }
                let expSum = expValues.values.reduce(0.0, +)
                normalizedProbs = expValues.mapValues { $0 / expSum }
                print("Debug: Softmax Probabilities: \(normalizedProbs)")
            } else {
                // Already normalized, so use directly
                normalizedProbs = classProbs
            }

            // Step 8: Calculate credibility score based on normalized probabilities
            let predictionLabel = output.classLabel
            let confidence = normalizedProbs[predictionLabel] ?? 0.0

            // Adjust credibility score based on the prediction label
            let credibility: Double
            if predictionLabel == "OR" {
                credibility = confidence // Use confidence directly for "OR"
            } else {
                credibility = 1.0 - confidence // Use 1 - confidence for "CG"
            }

            print("Debug: Prediction Label: \(predictionLabel)")
            print("Debug: Final Confidence Score: \(confidence)")
            print("Debug: Adjusted Credibility Score: \(credibility)")

            // Step 9: Update UI with prediction results
            DispatchQueue.main.async {
                credibilityScore = credibility // Assign adjusted credibility score
                predictionResult = predictionLabel == "OR" ? "Authentic" : "Fake"
            }
            
        } catch {
            print("Debug: Error during prediction - \(error.localizedDescription)")
            DispatchQueue.main.async {
                predictionResult = "Prediction error: \(error.localizedDescription)"
            }
        }
    }


    // Preprocessing and model loading functions
    func preprocessText(_ text: String) -> [Int] {
        let words = text.lowercased().split(separator: " ")
        return words.map { abs($0.hashValue % 10000) } // Simple hashing for indices
    }

    func padOrTruncate(sequence: [Int], toLength length: Int) -> [Int] {
        if sequence.count > length {
            return Array(sequence.prefix(length))
        } else if sequence.count < length {
            return sequence + Array(repeating: 0, count: length - sequence.count)
        } else {
            return sequence
        }
    }

    func loadModel() async -> FakeReviewClassifier_with_labels? {
        do {
            let config = MLModelConfiguration()
            let model = try FakeReviewClassifier_with_labels(configuration: config)
            return model
        } catch {
            print("Failed to load model: \(error)")
            return nil
        }
    }
}

//struct ContentViewReviews: View {
//    let reviews: [Review] = [
//        Review(title: "Great Product", rating: 5, authenticityScore: 0.90, content: "This product exceeded my expectations. The quality is excellent and the support team was super helpful. Highly recommended for anyone looking for a reliable solution."),
//        Review(title: "Not as Expected", rating: 2, authenticityScore: 0.59, content: "I found the product lacking in a few areas. It didn't perform as advertised and I was disappointed with the overall quality. However, customer service was decent.")
//    ]
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            ForEach(reviews) { review in
//                ReviewBox(review: review)
//            }
//        }
//        .padding()
//        
//    }
//}

//#Preview{
//    ContentViewReviews()
//}
//
