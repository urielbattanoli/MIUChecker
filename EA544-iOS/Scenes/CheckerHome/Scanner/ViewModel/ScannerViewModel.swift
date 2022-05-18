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
    func presentMember(_ member: Member)
}

final class ScannerViewModel: ScannerViewDelegate {
    
    weak var view: ScannerViewModelDelegate?
    
    var dailyTotal: Int = 0
    
    func verifyCode(_ code: String) {
        print(code)
        view?.startLoading(completion: nil)
        API<Member>.members(id: code).request(completion: { [weak self] response in
            self?.view?.stopLoading(completion: {
                switch response {
                case .success(let member):
                    self?.view?.presentMember(member)
                case .failure(let error):
                    let action = UIAlertAction(title: "Ok", style: .default) { _ in
                        self?.view?.runScanner()
                    }
                    self?.view?.showSimpleAlertController("Ops",
                                                          message: error.localizedDescription,
                                                          actions: [action],
                                                          cancel: false,
                                                          style: .alert)
                }
            })
        })
    }
}
