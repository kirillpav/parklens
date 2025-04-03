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

    @State private var photoDelegate = PhotoCaptureDelegate()

    var body: some View {
        ZStack {
            CameraPreviewView(captureSession: captureSession).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Button(action: {
                    let settings = AVCapturePhotoSettings()
                    photoOutput.capturePhoto(with: settings, delegate: photoDelegate)
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        
                }
                .padding(.bottom, 40)
            }
        }
        
        
    }
}
// todo - seld this to new file
class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
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
