//
//  UITableView+Extension.swift
//  Task
//
//  Created by Fady Sameh on 6/24/24.
//

import UIKit
import Foundation

public extension UITableView {
    func addFooterSpinnerView(spinnerColor: UIColor) {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = spinnerColor
        footerView.addSubview(spinner)
        footerView.layoutIfNeeded()
        spinner.startAnimating()
        
        tableFooterView = footerView
    }

    func registerCell<T: UITableViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: cellType.className, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cellType.className)
    }
    
    func register<T: UITableViewHeaderFooterView>(viewType: T.Type) {
        self.register(viewType, forHeaderFooterViewReuseIdentifier: viewType.className)
    }
    
    func register<T: UITableViewHeaderFooterView>(nibType: T.Type) {
        let nib = UINib(nibName: nibType.className, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: nibType.className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T? {
        let cell = self.dequeueReusableCell(withIdentifier: T.className)
        return cell as? T
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        let cell = self.dequeueReusableHeaderFooterView(withIdentifier: T.className)
        return cell as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: T.className, for: indexPath)
        return cell as! T
    }
    
    func updateEmptyState(emptyView: UIView?) {
        self.backgroundView = emptyView
    }
}

public extension NSObject {
    /// Value that represents a className as a string value
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return String(describing: self)
    }
}
