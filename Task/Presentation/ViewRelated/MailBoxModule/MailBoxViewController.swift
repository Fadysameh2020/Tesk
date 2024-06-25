//
//  MailBoxViewController.swift
//  Task
//
//  Created by Fady Sameh on 6/24/24.
//

import UIKit
import Combine

class MailBoxViewController: UIViewController {
    
    @IBOutlet weak var segmentedControlView: CustomSegmentControl!
    @IBOutlet private weak var mainTableView: UITableView!
    
    private var cancellables = Set<AnyCancellable>()

    var messages: [MailBoxMessage] = [
        MailBoxMessage(),
        MailBoxMessage(),
        MailBoxMessage(isRead: true),
        MailBoxMessage(isRead: true),
        MailBoxMessage(isRead: true),
        MailBoxMessage(isRead: true),
        MailBoxMessage(isRead: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    @IBAction func clearMessagesOnPressed(_ sender: Any) {
        messages.removeAll()
        mainTableView.reloadData()
    }
    

}

extension MailBoxViewController {
    private func setupUI() {
        registerCells()
        setupTableViewDelegates()
        setupBackButton()
        setupSegmentControlObserver()
    }
    
    private func setupTableViewDelegates() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    private func registerCells() {
        mainTableView.registerCell(cellType: MailTableViewCell.self)
    }
    
    private func setupSegmentControlObserver() {
        // Subscribe to segmentedControl changes
        segmentedControlView.segmentControl.publisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedIndex in
                guard let self = self else { return }
                print("Selected Segment Index: \(selectedIndex)")
                handleSegmentChange(index: selectedIndex)
                mainTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func handleSegmentChange(index: Int) {
        // Handle the segment change here
        switch index {
        case 0:
            // Handle first segment
            print("First segment selected")
            messages.removeAll()
            mainTableView.reloadData()
            messages = [
                MailBoxMessage(),
                MailBoxMessage(),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true)
            ]
        case 1:
            // Handle second segment
            print("Second segment selected")
            messages.removeAll()
            mainTableView.reloadData()
            messages = [
                MailBoxMessage(),
                MailBoxMessage(),
                MailBoxMessage(),
                MailBoxMessage(),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true)
            ]
        default:
            break
        }
    }
    
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

extension MailBoxViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MailTableViewCell
        
        let item = messages[indexPath.row]
        
        cell.titleLabel?.text = item.title
        cell.subTitleLabel?.text = item.subtitle
        
        if item.isRead {
            cell.readIcon.isHidden = true
            cell.titleLabel.textColor = UIColor.mssgTitle
            cell.subTitleLabel.textColor = UIColor.mssgSubtitle
        } else {
            cell.readIcon.isHidden = false
            cell.titleLabel.textColor = UIColor.black
            cell.subTitleLabel.textColor = UIColor.black
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("pressed on index: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69.32
    }
    
}
