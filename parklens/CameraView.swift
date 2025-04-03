//
//  CameraView.swift
//  parklens
//
//  Created by Kirill Pavlov on 4/2/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    private func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCaptureSession()
            print("Authorized")
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    print("Access granted")
                    DispatchQueue.main.async {
                        self.setupCaptureSession()
                    }
                } else {
                    print("Access denied")
//                    self.handleDismiss()
                }
            }
            
        case .denied:
            print("Denied")
//            self.handleDismiss()
        case .restricted:
            print("Restricted")
            
        default:
            print("Unknown")
            
        }
    }
    
    
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        let view = UIView(frame: UIScreen.main.bounds)
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput) else {
            return
        }
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraLayer.frame = view.bounds
        cameraLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraLayer)
        
        captureSession.startRunning()
//        self.setupUI()
    }
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CameraView()
}
