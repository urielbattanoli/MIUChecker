//
//  ScannerViewController.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import AVFoundation
import UIKit

protocol ScannerViewDelegate: AnyObject {
    var view: ScannerViewModelDelegate? { get set }
    var dailyTotal: Int { get }
    
    func verifyCode(_ code: String)
}

final class ScannerViewController: AppViewController {
    
    static func instantiate(viewModel: ScannerViewDelegate) -> ScannerViewController {
        return ScannerViewController(viewModel: viewModel)
    }
    
    @IBOutlet private var viewCameraPreview: UICameraPreviewView!
    @IBOutlet private var badgesReadLabel: UILabel!
    
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
        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        runScanner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
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
        metadataOutput.metadataObjectTypes = [.code128]
        
        viewCameraPreview.previewLayer.session = captureSession
        viewCameraPreview.previewLayer.videoGravity = .resizeAspectFill
        captureSession.startRunning()
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
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else { return }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        viewModel.verifyCode(stringValue)
    }
}

// MARK: - ScannerViewModelDelegate
extension ScannerViewController: ScannerViewModelDelegate {
    
    func update() {
        badgesReadLabel.text = "\(viewModel.dailyTotal) badges read today"
    }
    
    func runScanner() {
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }
}
