//
//  ViewController.swift
//  Face
//
//  Created by Zahra on 2024-03-17.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK - Variables

    private let captureSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addCameraInput()
    }
    
    // MARK: Helper function
    
    private func addCameraInput(){
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera,.builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else{
            fatalError("Np camera dectected. Please use a real camera, not a simulator.")
        }
        
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
    }

    private func showCameraFeed(){
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }

}

