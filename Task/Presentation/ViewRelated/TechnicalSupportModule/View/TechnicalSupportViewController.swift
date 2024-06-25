//
//  TechnicalSupportViewController.swift
//  Task
//
//  Created by Fady Sameh on 6/24/24.
//

import UIKit

class TechnicalSupportViewController: UIViewController {
    
    @IBOutlet private weak var mainTableView: UITableView!
    
    @IBOutlet private weak var supportEmailView: SupportEMailCustomView!
    
    @IBOutlet private weak var adminstrationCallView: AdministrationCallCustomView!
    
    let storeNames: [String] = [
        "Jeddah Storehouse",
        "Riyadh Storehouse",
        "Mecca Storehouse"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }

}

extension TechnicalSupportViewController {
    private func setupUI() {
        registerCells()
        setupTableViewDelegates()
        setupBackButton()
        
        supportEmailView.addTapGesture(tapNumber: 1) { [weak self] _ in
            guard let self = self else { return }
            let viewController = MailBoxViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        adminstrationCallView.addTapGesture(tapNumber: 1) { [weak self] _ in
            guard let self = self else { return }
            print("adminstrationCallView pressed")
        }
        
    }
    
    private func setupTableViewDelegates() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    private func registerCells() {
        mainTableView.registerCell(cellType: MailBoxTableViewCell.self)
        mainTableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "BackButton"), for: .normal)
        backButton.setTitle("Technical support", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc
    func backButtonTapped() {
        // Action for the custom back button
        self.navigationController?.popViewController(animated: true)
    }
}

extension TechnicalSupportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MailBoxTableViewCell
        
        cell.titleLabel?.text = storeNames[indexPath.row]
        cell.subTitleLabel?.text = "+966 (297) 059-1607"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = MailBoxViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.16
    }
    
}
