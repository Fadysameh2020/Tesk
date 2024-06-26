//
//  NotificationViewController.swift
//  Task
//
//  Created by Fady Sameh on 6/26/24.
//

import UIKit
import Combine

class NotificationViewController: UIViewController {
    
    @IBOutlet private weak var mainTableView: UITableView!
    
    private var cancellables = Set<AnyCancellable>()
    
    lazy private var alertView: DeleteAlertView = {
        let alert = DeleteAlertView()
        alert.layer.cornerRadius = 16
        alert.translatesAutoresizingMaskIntoConstraints = false 
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
    }
    
    @IBAction func clearMessagesOnPressed(_ sender: Any) {
        showAlertView()
    }
    
}

extension NotificationViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        removeAlertView()
    }
    
}

extension NotificationViewController {
    private func setupUI() {
        registerCells()
        setupTableViewDelegates()
        setupBackButton()
    }
    
    private func setupAddNewMailAlert() {
        alertView
            .addObserver()
        
        alertView
            .deleteButtonPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                messages.removeAll()
                mainTableView.reloadData()
                removeAlertView()
            }
            .store(in: &cancellables)
        
        alertView
            .cancelButtonPublisher
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
                alertView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5) // 5/6 of the view's height
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
                self.mainTableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                self.alertView.tintColor = UIColor.white
                
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
                self.mainTableView.backgroundColor = UIColor.white
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
        mainTableView.registerCell(cellType: NotificationTableViewCell.self)
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

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as NotificationTableViewCell
        
        let item = messages[indexPath.row]
        
        cell.titleLabel?.text = item.title
        cell.subTitleLabel?.text = item.subtitle
        
        if item.isRead {
            cell.titleLabel.textColor = UIColor.mssgTitle
            cell.subTitleLabel.textColor = UIColor.mssgSubtitle
            cell.backgroundColor = UIColor.white
        } else {
            cell.titleLabel.textColor = UIColor.black
            cell.subTitleLabel.textColor = UIColor.black
            cell.backgroundColor = UIColor.notification
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.messages.remove(at: indexPath.row)
            mainTableView.deleteRows(at: [indexPath], with: .left)
            mainTableView.reloadData()
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.deleteViewBackground
        deleteAction.image = UIImage.deletButton
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
}
