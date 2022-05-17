//
//  ScannerViewModel.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

protocol ScannerViewModelDelegate: AppViewModelDelegate {
    func update()
    func runScanner()
}

final class ScannerViewModel: ScannerViewDelegate {
    
    weak var view: ScannerViewModelDelegate?
    
    var dailyTotal: Int = 0
    
    func verifyCode(_ code: String) {
        print(code)
        let ok = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.view?.runScanner()
        }
        view?.showSimpleAlertController(code, message: nil, actions: [ok], cancel: false, style: .alert)
    }
    
    private func loadTransactions() {
        
    }
}
