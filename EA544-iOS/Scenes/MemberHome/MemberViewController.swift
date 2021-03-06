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
    var expDate: String { get }
    var showQRCode: Bool { get }
    var transactionsViewModel: TransactionsViewModel { get }
    func checkIn()
}

final class MemberViewController: AppViewController {
    
    static func instantiate(viewModel: MemberViewDelegate) -> MemberViewController {
        return MemberViewController(viewModel: viewModel)
    }
    
    @IBOutlet private weak var transactionsButton: UIButton!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileNameLabel: UILabel!
    @IBOutlet private weak var profileIdLabel: UILabel!
    @IBOutlet private weak var qrCodeBGView: UIView!
    @IBOutlet private weak var qrCodeImageView: UIImageView!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var expDateLabel: UILabel!
    
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
        expDateLabel.text = viewModel.expDate
        transactionsButton.isHidden = !viewModel.showQRCode
        qrCodeBGView.isHidden = !viewModel.showQRCode
        buttonsStackView.isHidden = viewModel.showQRCode
        view.backgroundColor = viewModel.showQRCode ? .white : .clear
    }
    
    @IBAction private func transactionsTouched(_ sender: UIButton) {
        TransactionsViewController.present(in: self, viewModel: viewModel.transactionsViewModel)
    }
    
    @IBAction private func confirmTouched(_ sender: UIButton) {
        viewModel.checkIn()
    }
    
    @IBAction private func cancelTouched(_ sender: UIButton) {
        dismiss()
    }
}
