//
//  MemberViewController.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

protocol MemberViewDelegate: AnyObject {
    
    var view: AppViewModelDelegate? { get set }
    var profileImageUrl: String { get }
    var profileName: String { get }
    var profileId: String { get }
    var qrCodeImage: UIImage? { get }
}

final class MemberViewController: AppViewController {
    
    static func present(in controller: UIViewController, viewModel: MemberViewDelegate) {
        let view = MemberViewController(viewModel: viewModel)
        viewModel.view = view
        
        let navigation = AppNavigationController(rootViewController: view)
        navigation.isNavigationBarHidden = true
        navigation.modalPresentationStyle = .fullScreen
        navigation.modalTransitionStyle = .crossDissolve
        
        controller.present(navigation, animated: true)
    }
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileNameLabel: UILabel!
    @IBOutlet private weak var profileIdLabel: UILabel!
    @IBOutlet private weak var qrCodeImageView: UIImageView!
    
    private let viewModel: MemberViewDelegate
    
    private init(viewModel: MemberViewDelegate) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        profileImageView.setProfileImage(url: viewModel.profileImageUrl)
        profileNameLabel.text = viewModel.profileName
        profileIdLabel.text = viewModel.profileId
        qrCodeImageView.image = viewModel.qrCodeImage
    }
}
