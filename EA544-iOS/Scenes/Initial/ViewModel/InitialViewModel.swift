//
//  InitialViewModel.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation

protocol InitialNavigation: AnyObject {
    
    func openCheckerHome()
    func openMemberHome(_ member: Member)
    func openLogin()
    func logout()
}

final class InitialViewModel {
    
    weak var navigation: InitialNavigation?
    
    func route() {
        navigation?.openCheckerHome()
        return
        guard let member = Member.current else {
            navigation?.openLogin()
            return
        }
        if member.isLocation {
            navigation?.openCheckerHome()
        } else {
            navigation?.openMemberHome(member)
        }
    }
    
    func logout() {
    }
}
