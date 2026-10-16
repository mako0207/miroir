import SwiftUI
import AVFoundation
import CoreImage
import UIKit
import Combine

class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    @Published var processedImage: UIImage? = nil
    @Published var blurIntensity: Double = 0.5
    @Published var lipIntensity: Double = 0.6

    let session = AVCaptureSession()

    private let context = CIContext()
    private let lock = NSLock()

    private var internalCIColor =
        CIColor(color: UIColor(
            red: 0.95,
            green: 0.20,
            blue: 0.30,
            alpha: 1.0
        ))

    func setupCamera() {
        guard !session.isRunning else { return }

        session.sessionPreset = .hd1280x720

        guard let frontCamera =
                AVCaptureDevice.default(
                    .builtInWideAngleCamera,
                    for: .video,
                    position: .front
                ),
              let input =
                try? AVCaptureDeviceInput(device: frontCamera)
        else {
            return
        }

        if (try? frontCamera.lockForConfiguration()) != nil {

            if frontCamera.activeFormat.videoMaxZoomFactor >= 2.0 {
                frontCamera.videoZoomFactor = 2.0
            }

            frontCamera.unlockForConfiguration()
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let output = AVCaptureVideoDataOutput()

        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String:
                kCVPixelFormatType_32BGRA
        ]

        output.setSampleBufferDelegate(
            self,
            queue: DispatchQueue(
                label: "cameraQueue",
                qos: .userInteractive
            )
        )

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        if let connection = output.connection(with: .video) {

            if #available(iOS 17.0, *) {
                if connection.isVideoRotationAngleSupported(90) {
                    connection.videoRotationAngle = 90
                }
            } else {
                if connection.isVideoOrientationSupported {
                    connection.videoOrientation = .portrait
                }
            }

            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = true
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    func setMakeupColor(_ color: Color) {

        lock.lock()

        let uiColor = UIColor(color)
        internalCIColor = CIColor(color: uiColor)

        lock.unlock()
    }

    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {

        guard let imageBuffer =
                CMSampleBufferGetImageBuffer(sampleBuffer)
        else {
            return
        }

        let sourceImage = CIImage(cvImageBuffer: imageBuffer)

        lock.lock()

        let activeColor = internalCIColor
        let currentBlur = blurIntensity
        let currentLipIntensity = lipIntensity

        lock.unlock()

        var processedCIImage = sourceImage

        // 美肌フィルター
        if let blurFilter = CIFilter(name: "CIBilateralFilter") {

            blurFilter.setValue(
                sourceImage,
                forKey: "inputImage"
            )

            blurFilter.setValue(
                max(0.01, currentBlur * 0.04),
                forKey: "inputDistanceCorrectionFactor"
            )

            blurFilter.setValue(
                0.03,
                forKey: "inputSigmaR"
            )

            if let skinImage = blurFilter.outputImage {
                processedCIImage = skinImage
            }
        }

        // メイクカラー
        if let colorGenerator =
            CIFilter(name: "CIConstantColorGenerator"),
           let blendFilter =
            CIFilter(name: "CIMultiplyBlendMode"),
           let alphaBlendFilter =
            CIFilter(name: "CIMix") {

            colorGenerator.setValue(
                activeColor,
                forKey: "inputColor"
            )

            if let solidColorImage =
                colorGenerator.outputImage {

                let croppedColorImage =
                    solidColorImage.cropped(
                        to: processedCIImage.extent
                    )

                blendFilter.setValue(
                    croppedColorImage,
                    forKey: "inputImage"
                )

                blendFilter.setValue(
                    processedCIImage,
                    forKey: "inputBackgroundImage"
                )

                if let blendedImage =
                    blendFilter.outputImage {

                    alphaBlendFilter.setValue(
                        processedCIImage,
                        forKey: "inputImage"
                    )

                    alphaBlendFilter.setValue(
                        blendedImage,
                        forKey: "inputBackgroundImage"
                    )

                    alphaBlendFilter.setValue(
                        currentLipIntensity * 0.6,
                        forKey: "inputAmount"
                    )

                    if let finalCIImage =
                        alphaBlendFilter.outputImage {

                        processedCIImage = finalCIImage
                    }
                }
            }
        }

        // UIImageへ変換
        if let cgImage =
            context.createCGImage(
                processedCIImage,
                from: processedCIImage.extent
            ) {

            let uiImage = UIImage(cgImage: cgImage)

            DispatchQueue.main.async {
                self.processedImage = uiImage
            }
        }
    }
}
