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
    
    @IBOutlet weak var addButton: UIButton!
    private var cancellables = Set<AnyCancellable>()
    
    lazy private var alertView: NewMailBoxView = {
        let alert = NewMailBoxView()
        alert.layer.cornerRadius = 16
        alert.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        return alert
    }()
    
    private var alertViewCenterYConstraint: NSLayoutConstraint?
    private var alertViewBottomConstraint: NSLayoutConstraint?
    
    var messages: [MailBoxMessage] = [
        MailBoxMessage(),
        MailBoxMessage(),
        MailBoxMessage(),
        MailBoxMessage(),
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
        setupAddNewMailAlert()
        addButton.isHidden = false
    }
    
    @IBAction func clearMessagesOnPressed(_ sender: Any) {
        messages.removeAll()
        mainTableView.reloadData()
    }
    
    @IBAction func addMessageOnPressed(_ sender: Any) {
        showAlertView()
    }
    
}

extension MailBoxViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        removeAlertView()
    }
    
}

extension MailBoxViewController {
    private func setupUI() {
        registerCells()
        setupTableViewDelegates()
        setupBackButton()
        setupSegmentControlObserver()
    }
    
    private func setupAddNewMailAlert() {
        alertView
            .addObserver()
        
        alertView
            .doneButtonPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                removeAlertView()
            }
            .store(in: &cancellables)
    }
    
    private func showAlertView() {
        if !alertView.isDescendant(of: view) {
            self.view.addSubview(self.alertView)
            
            // Initial constraints for the alert view
            NSLayoutConstraint.activate([
                alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                alertView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.86) // 5/6 of the view's height
            ])
            
            alertViewCenterYConstraint = alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            alertViewCenterYConstraint?.isActive = true
            
            self.view.layoutIfNeeded()
            
            // Animate the alert view to the bottom of the screen
            UIView.animate(withDuration: 0.4, animations: {
                self.alertViewCenterYConstraint?.isActive = false
                self.alertViewBottomConstraint = self.alertView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                self.alertViewBottomConstraint?.isActive = true
                self.view.layoutIfNeeded()
                self.view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            })
            mainTableView.isUserInteractionEnabled = false
        }
    }
    
    private func removeAlertView() {
        if alertView.isDescendant(of: view) {
            // Animate the alert view back to the center of the screen
            UIView.animate(withDuration: 0.4, animations: {
                self.alertViewBottomConstraint?.isActive = false
                self.alertViewCenterYConstraint?.isActive = true
                self.view.layoutIfNeeded()
                self.view.backgroundColor = UIColor.white
            }) { [weak self] completed in
                guard let self = self else { return }
                if completed {
                    self.alertView.removeFromSuperview()
                }
            }
            mainTableView.isUserInteractionEnabled = true
        }
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
                MailBoxMessage(),
                MailBoxMessage(),
                MailBoxMessage(),
                MailBoxMessage(),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true),
                MailBoxMessage(isRead: true)
            ]
            addButton.isHidden = false
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
            addButton.isHidden = true
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
