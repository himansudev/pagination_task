//
//  UIViewControllerExtension.swift
//  Task_Himansu
//
//  Created by Himansu Panigrahi on 5/30/24.
//

import UIKit
extension UIViewController{
    func showAlert(
        title: String,
        message: String,
        actions: [
            (
                title: String,
                style: UIAlertAction.Style,
                handler: ((UIAlertAction) -> Void)?
            )
        ]
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: action.handler)
            alertController.addAction(alertAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
