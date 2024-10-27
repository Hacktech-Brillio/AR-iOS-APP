# 📱 Brillio Review Authenticator

**Barcode Review Authenticator** is an iOS app designed to help users quickly verify the authenticity of reviews for various products. Using barcode scanning powered by AVFoundation and an AI-powered fake review detection model, the app enables users to access reliable information before making purchasing decisions.

## ✨ Features

- 🛒 **Real-time Barcode Scanning**: Scan product barcodes with AVFoundation for quick access to product reviews.
- 🤖 **AI-Powered Review Authentication**: An embedded Core ML model analyzes reviews and flags suspicious content.
- ⭐️ **Review Display**: View authentic reviews immediately
- 🎨 **User-Friendly Interface**: Built with SwiftUI, the app offers a responsive and intuitive design.

## 🌐 Future Enhancements

This app is designed to be adaptable for **VisionOS**, allowing the experience to be expanded to augmented reality glasses in the future. Users will be able to view authenticated reviews directly within a hands-free AR environment.

## 📝 Usage

1. **Barcode Scanning**: Open the app and align a product barcode within the scanning frame. The app will detect the barcode and fetch associated reviews.
2. **Review Analysis**: Access a summary of reviews, where the app flags fake or misleading ones. Each review includes an "Authenticity Score" powered by our AI model.

## 💡 Technology Stack

- 🖥 **Swift** for iOS development
- 🎨 **SwiftUI** for UI design
- 📸 **AVFoundation** for barcode scanning
- 🧠 **Core ML** for on-device AI model inference
- 🐍 **Python & PyTorch** for model training (converted to Core ML for iOS compatibility)

## 🤖 AI Model

The app’s AI component uses a custom LSTM-based PyTorch model to detect fake reviews. After being trained on labeled data, this model was converted into a Core ML format for optimized on-device performance.

## 🥽 Future VisionOS Integration

In future releases, this app will be enhanced to support **VisionOS**, providing users with an immersive AR experience. VisionOS integration will allow users to view review data within an AR environment, enhancing accessibility and usability.
