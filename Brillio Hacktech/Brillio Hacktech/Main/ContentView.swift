//
//  ContentView.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 25.10.2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var scannedCode: String?
    @State private var showingLoadingView = false
    @State private var isScanning = true // Controls whether the scanner is active

    var body: some View {
        NavigationStack {
            ZStack {
                if isScanning {
                    BarcodeScannerView(onScan: { scannedCode in
                        self.scannedCode = scannedCode
                        print("Barcode: \(scannedCode)")
                        self.showingLoadingView = true
                        self.isScanning = false // Stop scanning when navigating away
                    }, isScanning: $isScanning)
                    .edgesIgnoringSafeArea(.all)
                }

                VStack {
                    HStack {
                        Button(action: {
                            // History button action (to be implemented)
                        }) {
                            Image(systemName: "clock")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .padding(.leading, 20)

                        Spacer()
                    }
                    Spacer()
                    Image(systemName: "viewfinder.rectangular")
                        .resizable()
                        .foregroundStyle(.white)
                        .scaledToFit()
                        .padding(.horizontal, 30)
                        .fontWeight(.ultraLight)

                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.white)
                            .frame(height: 100)
                        Text("Please scan your barcode")
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .navigationDestination(isPresented: $showingLoadingView) {
                LoadingView(scannedCode: scannedCode ?? "")
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                print("restart camera")
                isScanning = true

            }
        }

        .navigationViewStyle(StackNavigationViewStyle())
    }
}



#Preview {
    ContentView()
}
