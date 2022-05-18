//
//  TransactionsViewModel.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/18/22.
//

import Foundation

protocol TransactionsViewModelDelegate: AppViewModelDelegate {
    
    func update()
}

final class TransactionsViewModel: TransactionsViewDelegate {
    
    weak var view: TransactionsViewModelDelegate?
    
    private let member: Member
    private var transactions: [Transaction] = []
    
    init(member: Member) {
        self.member = member
    }
    
    func load() {
        view?.startLoading(completion: {
            API<[Transaction]>.transactions(id: self.member.id).request(completion: { [weak self] response in
                self?.view?.stopLoading(completion: {
                    switch response {
                    case .success(let transactions):
                        self?.transactions = transactions
                        self?.view?.update()
                    case .failure(let error):
                        self?.view?.error(message: error.localizedDescription)
                    }
                })
            })
        })
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return transactions.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> CellComponent? {
        return CellComponent(reuseId: TransactionTableViewCell.reuseId,
                             data: transactions[indexPath.row])
    }
}
