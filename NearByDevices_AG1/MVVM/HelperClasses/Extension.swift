//
//  Extension.swift
//  NearByDevices_AG1
//
//  Created by Mac on 13/03/23.
//

import UIKit

extension UIViewController {
    
    //MARK:- Display Toast Methos
    func displayAlertMessage(_ message: String) {
        let alert = UIAlertController(title: AppInfo.AppName, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: AlertsTitle.okay, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UITableView {
    
    func registeredXibCell(_ identifier: String) {
        self.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}


