//
//  AppTableViewCell.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/18/22.
//

import UIKit

class AppTableViewCell: NibRegistrableTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        setTheme()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setTheme()
    }

    func setTheme() {}
}
