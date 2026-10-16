//
//  CameraModel.swift
//  camera
//
//  Created by 高畠眞子 on 2026/05/22.
//

import SwiftUI
import AVFoundation
import UIKit
import Combine

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {

    @Published var capturedImage: UIImage?

    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()

    override init() {
        super.init()
        setupCamera()
    }

    func setupCamera() {

        session.beginConfiguration()

        guard
            let device = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .front
            ),
            let input = try? AVCaptureDeviceInput(device: device)
        else {
            session.commitConfiguration()
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()

        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }

    // 撮影
    func takePhoto() {

        let settings = AVCapturePhotoSettings()

        output.capturePhoto(with: settings, delegate: self)
    }

    // ← ここ！！！！
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {

        guard let data = photo.fileDataRepresentation() else {
            return
        }

        guard let image = UIImage(data: data) else {
            return
        }

        DispatchQueue.main.async {

            self.capturedImage = image

            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            print("保存成功")
        }
    }
}
