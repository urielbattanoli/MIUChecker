//
//  InitialViewModel.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation

protocol InitialViewModelDelegate: AppViewModelDelegate {
    
    func openCheckerHome()
    func openMemberHome(_ member: Member)
    func openLogin()
}

final class InitialViewModel {
    
    weak var view: InitialViewModelDelegate?
    
    func route() {
        guard let member = Member.current else {
            view?.openLogin()
            return
        }
        if member.isLocation {
            view?.openCheckerHome()
        } else {
            view?.openMemberHome(member)
        }
    }
    
    func logout() {
    }
}
