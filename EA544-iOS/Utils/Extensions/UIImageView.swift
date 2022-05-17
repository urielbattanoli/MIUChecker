//
//  UIImageView.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setProfileImage(url: String) {
        let placeholder = #imageLiteral(resourceName: "user")
        set(url: URL(string: url)!, placeholder: placeholder)
    }
    
    private func set(url: URL, placeholder: UIImage? = .none, completion: (() -> Void)? = .none, mode: UIImage.RenderingMode = .automatic) {
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.6)),
                .cacheOriginalImage,
                .imageModifier(RenderingModeImageModifier(renderingMode: mode))
            ],
            completionHandler: { _ in
                completion?()
            }
        )
    }
}
