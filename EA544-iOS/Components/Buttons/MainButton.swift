//
//  MainButton.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

final class MainButton: UIButton {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setTheme()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTheme()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTheme()
    }
    
    func setTheme() {
        backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.7019607843, blue: 0.431372549, alpha: 1)
        setTitleColor(.white, for: .normal)
        setCorner(6)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    }
}
