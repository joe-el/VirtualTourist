//
//  UIViewController+Extension.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/5/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func handleFailureAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // Start or Stop activityIndicator:
//    func setLogginIn(_ logginIn : Bool) {
//        if logginIn {
//            self.activityIndicator.startAnimating()
//        } else {
//            self.activityIndicator.stopAnimating()
//        }
    // Disable login's view while activityIndiciator is spinnibg:
//        self.emailTextField.isEnabled = !logginIn
//        self.passwordTextField.isEnabled = !logginIn
//        self.loginButton.isEnabled = !logginIn
//        self.loginViaWebsiteButton.isEnabled = !logginIn
    
}
