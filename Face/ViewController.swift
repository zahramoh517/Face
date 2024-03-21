//
//  ViewController.swift
//  Face
//
//  Created by Zahra on 2024-03-17.
//

//import UIKit
import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    private let videoDataOutput = AVCaptureVideoDataOutput()

    private let captureSession = AVCaptureSession()

    /// Using `lazy` keyword because the `captureSession` needs to be loaded before we can use the preview layer.
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addCameraInput()
        showCameraFeed()
        
        captureSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.frame
    }
    
    // MARK: - Helper Functions
    
    private func addCameraInput(){
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera,.builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else{
            fatalError("No camera detected. Please use a real camera, not a simulator.")
        }
        
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
    }

    private func showCameraFeed(){
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }

    private func getCameraFrame(){
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        captureSession.addOutput(videoDataOutput)
        
        guard let connection = videoDataOutput.connections(with: .video), connection.isVideoOrientationSupported else{
            return
        }
        connection.videoOrientation = .portrait
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    
}
