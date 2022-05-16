//
//  InitialViewModel.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation

protocol InitialViewModelDelegate: AnyObject {
    
    func openHome()
    func openLogin()
}

final class InitialViewModel {
    
    weak var delegate: InitialViewModelDelegate?
    
}
