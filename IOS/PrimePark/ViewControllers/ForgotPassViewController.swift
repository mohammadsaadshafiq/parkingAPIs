//
//  ForgotPassViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 22/12/2021.
//

import UIKit

class ForgotPassViewController: UIViewController {
    
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var newPassField: UITextField!
    @IBOutlet weak var oldPassField: UITextField!
    @IBOutlet weak var newPassErrLabel: UILabel!
    @IBOutlet weak var oldPassErrLabel: UILabel!
    @IBOutlet weak var confirmPassErrLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        emailField.delegate = self
        confirmPassField.delegate = self
        newPassField.delegate = self
        oldPassField.delegate = self
        setupFieldPlaceholderColor("Email *", emailField)
        setupPlaceholderColor("Email *", "*", emailField)
        setupFieldPlaceholderColor("Old Password", oldPassField)
        setupFieldPlaceholderColor("New Password", newPassField)
        setupFieldPlaceholderColor("Confirm New Password", confirmPassField)
    }
    
    private func hideErrorLabels() {
        
    }
    
    private func setupFieldPlaceholderColor(_ text: String, _ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: text,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x353535).withAlphaComponent(0.8)])
    }
    
    private func setupPlaceholderColor(_ mainString: String, _ stringToColor: String, _ textField: UITextField) {
        let range = (mainString as NSString).range(of: stringToColor)

        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        textField.attributedPlaceholder = mutableAttributedString
    }
    
    @IBAction
    func submitBtnAction(_ sender: UIButton) {
        
        let emailText = emailField.text ?? ""
        let conPassText = confirmPassField.text ?? ""
        let newPassText = newPassField.text ?? ""
        let oldPassText = oldPassField.text ?? ""
        
        if emailText == "" {
            Utils.showAlert("Failed", "Please enter your e-mail", self)
        } else if !Utils.isValidEmail(emailText) {
            Utils.showAlert("Failed", "Email address is not valid", self)
        } else if oldPassText == "" {
            Utils.showAlert("Failed", "Please enter your old password", self)
        } else if newPassText == "" {
            Utils.showAlert("Failed", "Please enter your new password", self)
        } else if Utils.isValidPassword(mypassword: newPassText) {
            Utils.showAlert("Failed", "Password must contain atleast 8 characters and atleast 1 upper case letter, 1 lowercase letter, 1 special character and 1 number", self)
        } else if conPassText == "" {
            Utils.showAlert("Failed", "Please confirm new password", self)
        } else if newPassText != conPassText {
            Utils.showAlert("Failed", "Password must match", self)
        } else {
            
        }
    }
    
}

//MARK: - Text Field Delegate Methods
extension ForgotPassViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            textField.resignFirstResponder()
            oldPassField.becomeFirstResponder()
        } else if textField == oldPassField {
            textField.resignFirstResponder()
            newPassField.becomeFirstResponder()
        } else if textField == newPassField {
            textField.resignFirstResponder()
            confirmPassField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == emailField {
            let maxLength = 50
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else {
            return true
        }
        
    }
}



