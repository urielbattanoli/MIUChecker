//
//  ScannerViewModel.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation

protocol ScannerViewModelDelegate: AppViewModelDelegate {
    
}

final class ScannerViewModel: ScannerViewDelegate {
    
    weak var view: ScannerViewModelDelegate?
    
    func verifyCode(_ code: String) {
        
    }
}
