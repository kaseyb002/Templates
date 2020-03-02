//
//  UIViewController+Extensions.swift
//  ChildVC
//
//  Created by Kasey Baughan on 1/3/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit
import MessageUI

// MARK: Embedding Child VCs
extension UIViewController {
    
    func embed(_ childVC: UIViewController,
               into container: UIView,
               fadeInDuration: TimeInterval? = nil) {
        container.subviews.forEach { $0.removeFromSuperview() }
        
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
        
        childVC.willMove(toParent: self)
        
        addChild(childVC)
        
        childVC.view.frame = container.bounds
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(childVC.view)
        
        NSLayoutConstraint.activate([
            childVC.view.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            container.bottomAnchor.constraint(equalTo: childVC.view.bottomAnchor, constant: 0),
            
            childVC.view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            container.trailingAnchor.constraint(equalTo: childVC.view.trailingAnchor, constant: 0)
        ])
        
        childVC.didMove(toParent: self)
        
        container.backgroundColor = .clear // IB has default white background which is annoying
        
        if let fadeInDuration = fadeInDuration {
            container.alpha = 0.0
            UIView.animate(withDuration: fadeInDuration) { container.alpha = 1.0 }
        }
    }
}


// MARK: Alerts and Action Sheets
extension UIViewController {
    
    @discardableResult
    func alert(title: String,
               message: String? = nil,
               actions: [UIAlertAction],
               includeCancel: Bool = true) -> UIAlertController {
        return showAlert(title: title,
                         message: message,
                         actions: actions,
                         includeCancel: includeCancel,
                         preferredStyle: .alert)
    }
    
    @discardableResult
    func actionSheet(title: String?,
                     message: String? = nil,
                     actions: [UIAlertAction],
                     includeCancel: Bool = true) -> UIAlertController {
        return showAlert(title: title,
                         message: message,
                         actions: actions,
                         includeCancel: includeCancel,
                         preferredStyle: .actionSheet)
    }
    
    func okAlert(_ title: String, message: String? = nil) {
        alert(title: title,
              message: message,
              actions: [UIAlertAction(title: "OK", style: .default, handler: {_ in})],
              includeCancel: false)
    }
    
    private func showAlert(title: String?,
                           message: String? = nil,
                           actions: [UIAlertAction],
                           includeCancel: Bool = true,
                           preferredStyle: UIAlertController.Style) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)
        
        actions.forEach { action in
            alertController.addAction(action)
        }
        
        if includeCancel {
            alertController.addAction(UIAlertAction(title: "Cancel",
                                                    style: .cancel,
                                                    handler: nil))
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
        
        return alertController
    }
}

// MARK: Email
extension UIViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail(to address: String,
                   subject: String? = nil,
                   body: String? = nil) {
        guard MFMailComposeViewController.canSendMail() else {
            okAlert("No Email",
                    message: "You must setup an email account.")
            return
        }
        let toRecipents = [address]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        subject.map { mc.setSubject($0) }
        body.map { mc.setMessageBody($0, isHTML: false) }
        mc.setToRecipients(toRecipents)
        
        present(mc, animated: true, completion: nil)
    }
    
    public func mailComposeController(_ controller:MFMailComposeViewController,
                                      didFinishWith result:MFMailComposeResult,
                                      error:Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        @unknown default:
            print("Some new use case occurred")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    
    func share(text: String) {
        let activityVC = UIActivityViewController(activityItems: [text],
                                                  applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    func text(phones: [String], message: String? = nil) {
        let messageComposer = MessageComposer()
        if (messageComposer.canSendText()) {
            let messageComposeVC = messageComposer.configuredMessageComposeViewController(recipients: phones)
            messageComposeVC.messageComposeDelegate = self
            messageComposeVC.body = message
            present(messageComposeVC, animated: true, completion: nil)
        } else {
            okAlert("Cannot Send Text",
                    message: "Your device is not able to send text messages.")
        }
    }
}

//MARK: - Text Delegate
extension UIViewController: MFMessageComposeViewControllerDelegate {
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                             didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled, .sent:
            break
        case .failed:
            okAlert("Text Failed")
        @unknown default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
