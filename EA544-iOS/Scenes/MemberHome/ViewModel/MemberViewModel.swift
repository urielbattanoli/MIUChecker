//
//  MemberViewModel.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

protocol MemberViewModelDelegate: AppViewModelDelegate {
    
}

protocol CheckInDelegate: AnyObject {
    func didCheckIn()
    func runScanner()
}

final class MemberViewModel: MemberViewDelegate {
    
    weak var view: AppViewModelDelegate?
    
    private let member: Member
    private weak var delegate: CheckInDelegate?
    
    init(member: Member, delegate: CheckInDelegate? = nil) {
        self.member = member
        self.delegate = delegate
    }
    
    deinit {
        delegate?.runScanner()
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
        guard let locationId = Defaults.shared.location_id,
                let planId = Defaults.shared.plan_id else { return }
        view?.startLoading(completion: nil)
        API<EmptyResult>.checkIn(id: member.id).request(params: ["locationId": locationId, "planId": planId], completion: { [weak self] response in
            self?.view?.stopLoading(completion: {
                if case .failure(let error) = response {
                    self?.view?.error(message: error.localizedDescription)
                    return
                }
                self?.delegate?.didCheckIn()
                self?.view?.dismiss()
            })
        })
    }
}
