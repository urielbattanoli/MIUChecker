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
    func presentLogin()
}

final class ScannerViewModel: ScannerViewDelegate {
    
    weak var view: ScannerViewModelDelegate?
    weak var navigation: ScannerNavigation?
    private let formatter: DateFormatter
    
    var dailyTotal: Int = Defaults.shared.attendances.count {
        didSet {
            view?.update()
        }
    }
    
    init() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter = df
        loadTransactions()
    }
    
    func verifyCode(_ code: String) {
        dailyTotal += 1
        let att = Attendance(barcode: code,
                             scanDateTime: formatter.string(from: Date()))
        Defaults.shared.attendances.append(att.toDictionary())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view?.runScanner()
        }
    }
    
    private func loadTransactions() {
    }
    
    func sync() {
        guard Defaults.shared.token != nil else {
            navigation?.presentLogin()
            return
        }
        
        uploadAttedances()
    }
    
    private func uploadAttedances() {
        let attendances = Defaults.shared.attendances
        guard attendances.count > 0 else {
            view?.showSimpleAlertController("Ops!",
                                            message: "There aren't attendances to send",
                                            actions: nil,
                                            cancel: false,
                                            style: .alert)
            return
        }
        view?.startLoading(completion: {
            let query = URLQueryItem(name: "batch-insert", value: "true")
            API<EmptyResult>.saveAttendances.request(params: attendances, queries: [query], completion: { [weak self] result in
                self?.view?.stopLoading(completion: {
                    switch result {
                    case .success:
                        self?.dailyTotal = 0
                        Defaults.shared.attendances = []
                        self?.view?.showSimpleAlertController("Success!",
                                                              message: "All the saved attendances were uploaded to the server",
                                                              actions: nil,
                                                              cancel: false,
                                                              style: .alert)
                    case .failure(let error):
                        let tryNow = UIAlertAction(title: "Try again now", style: .default) { [weak self] _ in
                            self?.sync()
                        }
                        self?.view?.showSimpleAlertController("Error",
                                                              message: error.localizedDescription,
                                                              actions: [tryNow],
                                                              cancel: true,
                                                              style: .alert)
                        
                    }
                })
            })
        })
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

// MARK: - LoginDelegate
extension ScannerViewModel: LoginDelegate {
    
    func didLogin() {
        uploadAttedances()
    }
}
