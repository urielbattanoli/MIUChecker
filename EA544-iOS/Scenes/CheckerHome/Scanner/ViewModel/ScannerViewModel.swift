//
//  ScannerViewModel.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

protocol ScannerViewModelDelegate: AppViewModelDelegate {
    func runScanner()
}

final class ScannerViewModel: ScannerViewDelegate {
    
    weak var view: ScannerViewModelDelegate?
    
    func verifyCode(_ code: String) {
        print(code)
        let ok = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.view?.runScanner()
        }
        view?.showSimpleAlertController(code, message: nil, actions: [ok], cancel: false, style: .alert)
    }
}
