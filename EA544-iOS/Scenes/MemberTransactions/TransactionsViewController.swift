//
//  TransactionsViewController.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/18/22.
//

import UIKit

protocol TransactionsViewDelegate: AnyObject {
    
    var view: TransactionsViewModelDelegate? { get set }
    
    func load()
    func numberOfRowsInSection(_ section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> CellComponent?
}

final class TransactionsViewController: AppViewController {
    
    static func present(in controller: UIViewController, viewModel: TransactionsViewDelegate) {
        let view = TransactionsViewController(viewModel: viewModel)
        viewModel.view = view
        if let navigationController = controller.navigationController {
            navigationController.pushViewController(view, animated: true)
        } else {
            let navigationController = AppNavigationController(rootViewController: view)
            controller.present(navigationController, animated: true)
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: TransactionsViewDelegate
    
    private init(viewModel: TransactionsViewDelegate) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        title = "Transactions"
        viewModel.load()
        tableView.registerNib(for: TransactionTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - TransactionsViewModelDelegate
extension TransactionsViewController: TransactionsViewModelDelegate {
    
    func update() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension TransactionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellComp = viewModel.cellForRow(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellComp.reuseId, for: indexPath)
        (cell as? DynamicCellComponent)?.updateUI(with: cellComp.data)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TransactionsViewController: UITableViewDelegate {
    
}
