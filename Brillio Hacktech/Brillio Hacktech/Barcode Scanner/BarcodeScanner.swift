//
//  BarcodeScanner.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 25.10.2024.
//

import SwiftUI
import AVFoundation

import SwiftUI
import AVFoundation

struct BarcodeScannerView: UIViewControllerRepresentable {
    var onScan: (String) -> Void
    @Binding var isScanning: Bool

    func makeUIViewController(context: Context) -> ScannerViewController {
        let scannerVC = ScannerViewController()
        scannerVC.onScan = onScan
        return scannerVC
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
        if isScanning {
            uiViewController.startScanning()
        } else {
            uiViewController.stopScanning()
        }
    }
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var onScan: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
    }

    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // The user has previously granted access to the camera.
            setupCamera()
        case .notDetermined:
            // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showCameraAccessAlert()
                    }
                }
            }
        case .denied, .restricted:
            // The user has denied or restricted access.
            DispatchQueue.main.async {
                self.showCameraAccessAlert()
            }
        @unknown default:
            break
        }
    }

    func showCameraAccessAlert() {
        let alert = UIAlertController(
            title: "Camera Access Required",
            message: "Please allow camera access in Settings to scan barcodes.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

    func setupCamera() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            print("Failed to create video input")
            return
        }

        if (captureSession?.canAddInput(videoInput) == true) {
            captureSession?.addInput(videoInput)
        } else {
            print("Could not add video input to the session")
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession?.canAddOutput(metadataOutput) == true) {
            captureSession?.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [
                .ean8, .ean13, .pdf417, .qr, .code128, .code39, .code93
            ]
        } else {
            print("Could not add metadata output to the session")
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill

        if let previewLayer = previewLayer {
            view.layer.addSublayer(previewLayer)
        }

        // Start scanning
        startScanning()
    }

    func startScanning() {
        if captureSession == nil {
            setupCamera()
        }
        if let captureSession = captureSession, !captureSession.isRunning {
            DispatchQueue.global(qos: .background).async {
                captureSession.startRunning()
            }
        }
    }

    func stopScanning() {
        if let captureSession = captureSession, captureSession.isRunning {
            DispatchQueue.global(qos: .background).async {
                captureSession.stopRunning()
            }
        }
    }

    // Delegate method called when a barcode is detected
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        stopScanning() // Stop scanning after a code is detected

        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let code = metadataObject.stringValue {
            DispatchQueue.main.async {
                self.onScan?(code)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScanning()
    }

    // Remove setting captureSession to nil
    deinit {
        stopScanning()
        // Do not set captureSession = nil here
    }
}
