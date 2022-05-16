//
//  UICameraPreviewView.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit
import AVFoundation

final class UICameraPreviewView: UIView {
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    private var maskLayer: CAShapeLayer?
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
    
    func draw(boundingBox: CGRect) {
        let transform = CGAffineTransform(
            scaleX: 1,
            y: -1
        )
        .translatedBy(
            x: 0,
            y: -previewLayer.frame.height
        )
        
        let scale = CGAffineTransform.identity.scaledBy(
            x: previewLayer.frame.width,
            y: previewLayer.frame.height
        )
        
        let bounds = boundingBox
            .applying(scale)
            .applying(transform)
        
        createLayer(in: bounds)
    }
    
    private func createLayer(in rect: CGRect) {
        maskLayer?.removeFromSuperlayer()
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.cornerRadius = 10
        maskLayer.opacity = 0.75
        maskLayer.borderColor = UIColor.red.cgColor
        maskLayer.borderWidth = 5.0
        
        previewLayer.insertSublayer(maskLayer, at: 1)
        
        self.maskLayer = maskLayer
    }
}
