//
//  TransactionTableViewCell.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/18/22.
//

import UIKit

final class TransactionTableViewCell: AppTableViewCell {
    
    @IBOutlet private weak var localNameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
}

// MARK: - DynamicCellComponent
extension TransactionTableViewCell: DynamicCellComponent {
    
    func updateUI(with data: Any?) {
        guard let data = data as? Transaction else { return }
        
        localNameLabel.text = data.locationName
        dateLabel.text = data.createdDateTime
    }
}
