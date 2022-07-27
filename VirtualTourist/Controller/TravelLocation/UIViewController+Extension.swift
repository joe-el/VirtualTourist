//
//  UIViewController+Extension.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/5/22.
//

import Foundation
import UIKit

extension UIViewController {
    
//    func addStudentInformation(_ sender: UIBarButtonItem) {
//        let userHadPosted = UdacityAPIClient.Auth.objectId != ""
//
//        if userHadPosted {
//            // Create the action buttons for the alert.
//            let defaultAction = UIAlertAction(title: "Overwrite", style: .default) { (action) in
//                // Respond to user selection of the action.
//                self.handleAlertOverwriteResponse(userHadPosted: true)
//                }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//                // Respond to user selection of the action—which to cancel the alert.
//                }
//
//            // Create and configure the alert controller.
//            let postingAlert = UIAlertController(title: nil, message:  "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: .alert)
//            postingAlert.addAction(defaultAction)
//            postingAlert.addAction(cancelAction)
//
//            present(postingAlert, animated: true, completion: nil)
//        } else {
//            handleAlertOverwriteResponse(userHadPosted: false)
//        }
//    }
    
    //MARK: Helper Methods
    
//    func handleAlertOverwriteResponse(userHadPosted: Bool) {
//        UdacityAPIClient.Auth.pinAlreadyPosted = userHadPosted
//        self.performSegue(withIdentifier: "addLocation", sender: nil)
//    }
    
//    func openWebsiteLink(urlString: String?) {
//        guard let urlString = urlString else {
//            handleFailureAlert(title: "Failed to Open ", message: "No web address given.")
//            return
//        }
//
//        let studentWebSite = URL(string: urlString)
//
//        if let validURLString = studentWebSite {
//            let validURL: Bool = UIApplication.shared.canOpenURL(validURLString)
//            if validURL {
//                UIApplication.shared.open(validURLString, options: [:], completionHandler: nil)
//            } else {
//                handleFailureAlert(title: "Failed to Open ", message: "Invalid web address.")
//            }
//        } else {
//            handleFailureAlert(title: "Failed to Open ", message: "No web address given.")
//        }
//    }
    
    func handleFailureAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
