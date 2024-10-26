import SwiftUI
import CoreML

struct ReviewClassifierView: View {
    @State private var reviewText: String = "Profiles a family that provides a financial support system to families of all ages who have suffered through the past.  The family is also a solid foundation for the future of the great American cities."
    @State private var predictionResult: String = "Prediction will appear here"
    @State private var maxSeqLength: Int = 100  // Adjust based on your model's sequence length

    var body: some View {
        VStack {
            Text("Review Classifier")
                .font(.largeTitle)
                .padding()

            TextField("Enter review text", text: $reviewText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Classify Review") {
                Task {
                    await classifyReview()
                }
            }
            .padding()

            Text(predictionResult)
                .padding()
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
    }

    // Function to preprocess text and get prediction
    func classifyReview() async {
        guard let model = await loadModel() else {
            predictionResult = "Model loading failed."
            return
        }

        let processedInput = preprocessText(reviewText)

        do {
            let paddedInput = padOrTruncate(sequence: processedInput, toLength: maxSeqLength)
            let inputArray = try MLMultiArray(shape: [1, NSNumber(value: maxSeqLength)], dataType: .int32)

            for (index, value) in paddedInput.enumerated() {
                inputArray[[0, index] as [NSNumber]] = NSNumber(value: value)
            }

            let input = FakeReviewClassifier_with_labelsInput(input: inputArray)
            let output = try await model.prediction(input: input)

            // Retrieve the predicted class label
            let predictionLabel = output.classLabel

            // Apply softmax to class probabilities manually
            var adjustedProbabilities = [String: Double]()
            let expValues = output.classLabel_probs.mapValues { exp($0) }
            let expSum = expValues.values.reduce(0, +)

            for (label, value) in expValues {
                adjustedProbabilities[label] = value / expSum
            }

            // Print probabilities after softmax and their sum
            print("Adjusted Probabilities (after softmax): \(adjustedProbabilities)")
            print("Sum of Adjusted Probabilities: \(adjustedProbabilities.values.reduce(0, +))")

            // Retrieve and display the confidence score
            let confidenceScore = adjustedProbabilities[predictionLabel] ?? 0.0
            DispatchQueue.main.async {
                predictionResult = "Predicted Class: \(predictionLabel) with Confidence: \(confidenceScore * 100)%"
            }

        } catch {
            DispatchQueue.main.async {
                predictionResult = "Prediction error: \(error.localizedDescription)"
            }
        }
    }

    // Function to preprocess text to token indices
    func preprocessText(_ text: String) -> [Int] {
        // Tokenize and lowercase the input text
        let words = text.lowercased().split(separator: " ")

        // Map words to indices using a simple hashing mechanism
        let indices = words.map { word -> Int in
            return abs(word.hashValue % 10000)  // Generate an index using hash value
        }

        return indices
    }

    // Function to pad or truncate sequence to maxSeqLength
    func padOrTruncate(sequence: [Int], toLength length: Int) -> [Int] {
        if sequence.count > length {
            // Truncate the sequence
            return Array(sequence.prefix(length))
        } else if sequence.count < length {
            // Pad the sequence with zeros (assuming 0 is the padding index)
            return sequence + Array(repeating: 0, count: length - sequence.count)
        } else {
            // Sequence is already the correct length
            return sequence
        }
    }

    // Load your Core ML model
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

struct ReviewClassifierView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewClassifierView()
    }
}
