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

protocol ScannerNavigation: AnyObject {
    func presentMember(_ viewModel: MemberViewModel)
}

final class ScannerViewModel: ScannerViewDelegate {
    
    weak var view: ScannerViewModelDelegate?
    weak var navigation: ScannerNavigation?
    
    var dailyTotal: Int = 0
    
    func verifyCode(_ code: String) {
        print(code)
        view?.runScanner()
    }
    
    private func loadTransactions() {
        
    }
}

// MARK: - CheckInDelegate
extension ScannerViewModel: CheckInDelegate {
    
    func didCheckIn() {
        dailyTotal += 1
        view?.update()
    }
    
    func runScanner() {
        view?.runScanner()
    }
}
