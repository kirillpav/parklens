//
//  ContentView.swift
//  parklens
//
//  Created by Kirill Pavlov on 4/2/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()

    init() {
        setupCamera()
    }

    private func setupCamera() {
        captureSession.beginConfiguration()

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput) else {
                return
              }
        
        if captureSession.canAddInput(videoDeviceInput) {
            captureSession.addInput(videoDeviceInput)
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }

        
        captureSession.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
     }


    var body: some View {
        CameraPreviewView(captureSession: captureSession).edgesIgnoringSafeArea(.all)
    }
}
// todo - seld this to new file
class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let captureSession: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    ContentView()
}
