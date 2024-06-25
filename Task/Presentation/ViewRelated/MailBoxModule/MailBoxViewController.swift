//
//  MailBoxViewController.swift
//  Task
//
//  Created by Fady Sameh on 6/24/24.
//

import UIKit

class MailBoxViewController: UIViewController {

//    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var segmentedControlView: CustomSegmentControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        
    }

}

extension MailBoxViewController {
    private func setupUI() {
//        registerCells()
//        setupTableViewDelegates()
        setupBackButton()
    }
    
//    private func setupTableViewDelegates() {
//        mainTableView.delegate = self
//        mainTableView.dataSource = self
//    }
//    
//    private func registerCells() {
//        mainTableView.registerCell(cellType: MailBoxTableViewCell.self)
//        mainTableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
//    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "BackButton"), for: .normal)
        backButton.setTitle("  Mail Box", for: .normal)
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
