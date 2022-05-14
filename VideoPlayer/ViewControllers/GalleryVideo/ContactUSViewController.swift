//
//  ContactUSViewController.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//


import UIKit
import MessageUI


 class ContactUSViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet private var bgScrollView: UIScrollView!
    @IBOutlet private var topNaviView: UIView!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var sendButton: UIButton!
    
    @IBOutlet private var hederLabel: UILabel!
    
    @IBOutlet private var row1: UIView!
    @IBOutlet private var namePlaceholderLabel: UILabel!
    @IBOutlet private var nameTextView: UITextView!
    
    @IBOutlet private var row3: UIView!
    @IBOutlet private var messagePlaceholderLabel: UILabel!
    @IBOutlet private var messageTextView: UITextView!
    
    private var placeHolderTitleList = ["Your Name", "Your Message to Our Team"]
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .background()
        topNaviView.setTopNavigation()
        
        backButton.tintColor = .themecolor()
        
        bgScrollView.frame.size.height = self.view.bounds.height - topNaviView.frame.size.height
        bgScrollView.frame.origin.y = topNaviView.frame.size.height
        bgScrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        
        sendButton.layer.cornerRadius = 5
        sendButton.backgroundColor = .themecolor()

        hederLabel.text = hederLabel.text?.uppercased()
        row1.layer.borderColor = UIColor.clear.cgColor
        row3.layer.borderColor = UIColor.clear.cgColor
        
        namePlaceholderLabel.text = placeHolderTitleList[0]
        messagePlaceholderLabel.text = placeHolderTitleList[1]

    }
    
    
    
    @IBAction private func backbuttonclick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func sendbuttonclick(_ sender: Any) {
        var error = ""
        error = checkValidation(nameTextView)
        error = error + checkValidation(messageTextView)
        
        error = error.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
        
        if error != "" {
            showFieldErrorAlert(error)
        } else {
            sendUserdata()
        }
    }
    
    
    
    // MARK: -
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        getrowView(textView).layer.borderColor = UIColor.clear.cgColor
        
        let scrollypoint = textView == messageTextView ? 80 : 0
        bgScrollView.setContentOffset(CGPoint(x: 0, y: scrollypoint), animated: true)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        getplaceholderLabel(textView).isHidden = textView.text.count > 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        getplaceholderLabel(textView).isHidden = textView.text.count > 0
    }
    
    
    // MARK: -
    
    private func getplaceholderLabel(_ textView: UITextView) -> UILabel {
        
        if textView == nameTextView {
            return namePlaceholderLabel
        }

        return messagePlaceholderLabel
    }
    
    private func getrowView(_ textView: UITextView) -> UIView {
        
        if textView == nameTextView {
            return row1
        }

        return row3
    }
    
    private func checkValidation(_ textView: UITextView) -> String {
        
        if textView.text.count == 0 {
            getrowView(textView).layer.borderColor = UIColor.red.cgColor
            return errorMessage(textView)
        }

        if textView == messageTextView {
            
            guard textView.text.count > 15 else {
                getrowView(textView).layer.borderColor = UIColor.red.cgColor
                return errorMessage(textView)
            }
        }
        
        return ""
    }
    
    private func errorMessage(_ textView: UITextView) -> String {
        
        return "Field \"Your Message\" must contain at least 15 characters."

    }
    
    private func showFieldErrorAlert(_ message:String) {
        
        let alert = UIAlertController(title:message, message:nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



extension ContactUSViewController : MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    
    func sendUserdata() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let app_version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? ""
            let os_version = UIDevice.current.systemVersion
            let region = Locale.current.regionCode!
            let emailTitle = "Feedback & Bug Report from test player"
            let toRecipents = ["test@gmail.com"]
            
            let messageBody = "\(nameTextView.text!) \n\n \(messageTextView.text!) \n\n App Version: \(app_version) \n OS: \(region) - \(os_version)"
            
            let mc = MFMailComposeViewController()
            mc.delegate = self
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            
            present(mc, animated: true)
            
        } else {
            
            let alertController = UIAlertController(title: "Email Account Setup", message: "You haven't set your email account", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alertController, animated: true)
        }

    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
        self.nameTextView.text = nil
        self.namePlaceholderLabel.isHidden = false
        self.messageTextView.text = nil
        self.messagePlaceholderLabel.isHidden = false
    }
    
}
