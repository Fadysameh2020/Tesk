//
//  HomeViewController.swift
//  Task
//
//  Created by Fady Sameh on 6/24/24.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Technical support"

    }


    @IBAction func goToOtherScreens(_ sender: Any) {
        let viewController = TechnicalSupportViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }


}
