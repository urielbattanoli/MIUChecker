//
//  MemberViewModel.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

protocol MemberViewModelDelegate: AppViewModelDelegate {
    
}

final class MemberViewModel: MemberViewDelegate {
    
    weak var view: AppViewModelDelegate?
    
    private let member: Member
    
    init(member: Member) {
        self.member = member
    }
    
    var profileImageUrl: String {
        return "https://media-exp1.licdn.com/dms/image/C4D03AQFMlMrssSIswg/profile-displayphoto-shrink_800_800/0/1596219446849?e=1657756800&v=beta&t=SfEJaYhqSQBiTDB1ePP1vXxiPcCeY9k8TDaOlouOiTk"
    }
    
    var profileName: String {
        return member.name
    }
    
    var profileId: String {
        return "student id"
    }
    
    var qrCodeImage: UIImage? {
        return QRCode.generate(from: member.id)
    }
    
    var expDate: String {
        return "07/10/2022"
    }
    
    var showQRCode: Bool { return member.id == Member.current?.id }
    
    func checkIn() {
        
    }
}
