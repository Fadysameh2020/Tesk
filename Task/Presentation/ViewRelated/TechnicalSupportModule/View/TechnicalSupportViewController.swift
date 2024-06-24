//
//  TechnicalSupportViewController.swift
//  Task
//
//  Created by Fady Sameh on 6/24/24.
//

import UIKit

class TechnicalSupportViewController: UIViewController {
    
    @IBOutlet private weak var mainTableView: UITableView!
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MailBoxTableViewCell
        
        let mails: Int = 12
        let answered: Int = 11
        
        cell.titleLabel?.text = "Mail Box"
        cell.subTitleLabel?.text = "\(mails) Mails Sent. \(answered) Answered "
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = MailBoxViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! CustomHeaderView
        
        switch section {
        case 0:
            headerView.titleLabel.text = "SUPPORT EMAIL"
            headerView.titleLabel.textColor = .gray
        case 1:
            headerView.titleLabel.text = "Administration CALL"
            headerView.titleLabel.textColor = .gray
        default:
            headerView.titleLabel.text = "Storehouses CALL"
            headerView.titleLabel.textColor = .black

        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        switch section {
        case 0, 1:
            header.textLabel?.textColor = .gray
        case 2:
            header.textLabel?.textColor = .black
        default:
            header.textLabel?.textColor = .black
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.16
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // Adjust the height as needed
    }
    
}
