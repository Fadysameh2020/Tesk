//
//  MailTableViewCell.swift
//  Task
//
//  Created by Fady Sameh on 6/24/24.
//

import UIKit

class MailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var readIcon: UILabel!
    
    
}

struct MailBoxMessage {
    var title: String = "Lorem ipsum dolor sit"
    var subtitle: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum mollis nunc a molestie dictum."
    
    var isRead: Bool = false
    
}
