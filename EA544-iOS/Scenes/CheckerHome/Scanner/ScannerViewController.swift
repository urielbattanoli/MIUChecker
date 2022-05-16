//
//  ScannerViewController.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import AVFoundation
import UIKit

protocol ScannerViewDelegate {
    var view: ScannerViewModelDelegate? { get set }
    
    func verifyCode(_ code: String)
}

final class ScannerViewController: AppViewController {
    
    static func present(in controller: UIViewController, viewModel: ScannerViewDelegate) {
        let view = ScannerViewController(viewModel: viewModel)
        
        let navigation = AppNavigationController(rootViewController: view)
        
        navigation.isNavigationBarHidden = true
        navigation.modalPresentationStyle = .fullScreen
        navigation.modalTransitionStyle = .crossDissolve
        
        controller.present(navigation, animated: true)
    }
    
    @IBOutlet private var viewCameraPreview: UICameraPreviewView!
    
    private var captureSession: AVCaptureSession!
    private let viewModel: ScannerViewDelegate
    
    private init(viewModel: ScannerViewDelegate) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        let metadataOutput = AVCaptureMetadataOutput()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput),
              captureSession.canAddOutput(metadataOutput) else {
            failed()
            return
        }
        captureSession.addInput(videoInput)
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        viewCameraPreview.previewLayer.session = captureSession
        captureSession.startRunning()
    }
    
    private func found(code: String) {
        viewModel.verifyCode(code)
    }
    
    private func failed() {
        showSimpleAlertController("Scanning not supported",
                                  message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                                  actions: nil,
                                  cancel: false,
                                  style: .alert)
        captureSession = nil
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
}
