//
//  OTPAndGeneralInfoViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 22/12/2021.
//

import UIKit
import FlagPhoneNumber

protocol OTPAndGeneralInfoViewControllerDelegate: AnyObject {
    func selectedIndex(_ controller: OTPAndGeneralInfoViewController, ind: Int)
}

class OTPAndGeneralInfoViewController: UIViewController {
    
    weak var delegate: OTPAndGeneralInfoViewControllerDelegate?
    private var isTerms = false {
        didSet {
            enableDisableContinueBtn()
        }
    }
    private var isMarketing = false
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var fullnameErrorLabel: UILabel!
    @IBOutlet weak var confirmPassErrorLabel: UILabel!
    @IBOutlet weak var passErrorLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var mobileField: FPNTextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileNumView: UIView!
    @IBOutlet weak var getcodeBtn: UIButton!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var newCodeBtn: UIButton!
    @IBOutlet weak var verifyCodeBtn: UIButton!
    @IBOutlet weak var changeNumBtn: UIButton!
    @IBOutlet weak var officeAddTextview: UITextView!
    @IBOutlet weak var residenceTextView: UITextView!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var termsBtn: CheckBox!
    
    @IBOutlet weak var marketingBtn: CheckBox!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        otpView.isHidden = true
        mobileNumView.isHidden = false
        getcodeBtn.isHidden = false
        verifyCodeBtn.isHidden = true
        newCodeBtn.isHidden = true
        
        let attr2 = NSAttributedString(string: "Change Number", attributes:
                                        [.underlineStyle: NSUnderlineStyle.single.rawValue])
        changeNumBtn.setAttributedTitle(attr2, for: .normal)
        
        setupPlaceholderColor("E-mail *", "*", "E-mail", emailField)
        setupPlaceholderColor("Password *", "*", "Password", passwordField)
        setupPlaceholderColor("Confirm Password *", "*", "Confirm Password", confirmPassField)
        setupPlaceholderColor("Full Name *", "*", "Full Name", fullNameField)
        setupTextViewPlaceholders()
        //residenceTextView.delegate = self
        //officeAddTextview.delegate = self
        //residenceTextView.leftSpace()
       // officeAddTextview.leftSpace()
        emailField.delegate = self
        passwordField.delegate = self
        confirmPassField.delegate = self
        fullNameField.delegate = self
        setupPlaceholderColor("Mobile *", "*", "Mobile", mobileField)
        setupFieldPlaceholderColor("xxx xxx xxxx", mobileField)
        setupFieldPlaceholderColor("xxxx", otpField)
        setupPlaceholderColor("Mobile *", "*", "Mobile", mobileLabel)
        continueBtn.isEnabled = false
        [emailField, passwordField, confirmPassField, fullNameField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
        hideErrorLabels()
    }
    
    // MARK: Private Methods
    private func setupFieldPlaceholderColor(_ text: String, _ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: text,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xffffff).withAlphaComponent(0.8)])
    }
    
    private func hideErrorLabels() {
        emailErrorLabel.isHidden = true
        passErrorLabel.isHidden = true
        confirmPassErrorLabel.isHidden = true
        fullnameErrorLabel.isHidden = true
    }
    
    private func setupTextViewPlaceholders() {
        residenceTextView.text = "Resident Address"
        residenceTextView.textColor = UIColor(rgb: 0x353535).withAlphaComponent(0.8)
        
        officeAddTextview.text = "Office Address"
        officeAddTextview.textColor = UIColor(rgb: 0x353535).withAlphaComponent(0.8)
    }
    
    private func setupPlaceholderColor(_ mainString: String, _ stringToColor: String, _ secondToColor: String, _ textField: UITextField) {
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: mainString)
        attributedString.setColorForText(textForAttribute: stringToColor, withColor: UIColor.red)
        attributedString.setColorForText(textForAttribute: secondToColor, withColor: UIColor(rgb: 0x353535).withAlphaComponent(0.8))
        textField.attributedPlaceholder = attributedString
    }
    
    private func setupPlaceholderColor(_ mainString: String, _ stringToColor: String, _ secondToColor: String, _ label: UILabel) {
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: mainString)
        attributedString.setColorForText(textForAttribute: stringToColor, withColor: UIColor.red)
        attributedString.setColorForText(textForAttribute: secondToColor, withColor: UIColor.white)
        label.attributedText = attributedString
    }
    
    private func validateFields() {
        let emailText = emailField.text ?? ""
        let conPassText = confirmPassField.text ?? ""
        let passText = passwordField.text ?? ""
        let fullNameText = fullNameField.text ?? ""
        
        hideErrorLabels()
        if emailText == "" {
            emailErrorLabel.isHidden = false
            //Utils.showAlert("Failed", "Please enter your E-mail", self)
        } else if !Utils.isValidEmail(emailText) {
            emailErrorLabel.isHidden = false
            //Utils.showAlert("Failed", "Email address is not valid", self)
        }  else if passText == "" {
            passErrorLabel.isHidden = false
            passErrorLabel.text = "Please enter your Password"
            //Utils.showAlert("Failed", "Please enter your Password", self)
        } else if !Utils.isValidPassword(mypassword: passText) {
            passErrorLabel.isHidden = false
            passErrorLabel.text = "Password must contain atleast 8 characters and atleast 1 upper case letter, 1 lowercase letter, 1 special character and 1 number"
            //Utils.showAlert("Failed", "Password must contain atleast 8 characters and atleast 1 upper case letter, 1 lowercase letter, 1 special character and 1 number", self)
        } else if conPassText == "" {
            confirmPassErrorLabel.isHidden = false
            confirmPassErrorLabel.text = "Please confirm new Password"
            //Utils.showAlert("Failed", "Please confirm new Password", self)
        } else if passText != conPassText {
            confirmPassErrorLabel.isHidden = false
            confirmPassErrorLabel.text = "Please confirm new Password"
            //jkUtils.showAlert("Failed", "Password must match", self)
        } else if fullNameText == "" {
            fullnameErrorLabel.isHidden = false
            //Utils.showAlert("Failed", "Please enter your Fullname", self)
        } else {
            delegate?.selectedIndex(self, ind: 1)
        }
    }
    
    private func enableDisableContinueBtn() {
        guard
            let email = emailField.text, !email.isEmpty,
            let pass = passwordField.text, !pass.isEmpty,
            let conPass = confirmPassField.text, !conPass.isEmpty,
            let name = confirmPassField.text, !name.isEmpty,
            isTerms
        else {
            continueBtn.isEnabled = false
            continueBtn.backgroundColor = UIColor(rgb: 0xFDEC99)
            return
        }
        continueBtn.isEnabled = true
        continueBtn.backgroundColor = UIColor(rgb: 0xFAD000)
    }
    
    //  MARK: Actions
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        validateFields()
    }
    
    @IBAction func termsBtnAction(_ sender: CheckBox) {
        isTerms = !sender.isChecked
    }

    @IBAction func marketingBtnAction(_ sender: CheckBox) {
        isMarketing = sender.isChecked
    }
    
    @IBAction func getCodeBtnAction(_ sender: UIButton) {
        otpView.isHidden = false
        mobileNumView.isHidden = false
        getcodeBtn.isHidden = true
        verifyCodeBtn.isHidden = false
        newCodeBtn.isHidden = true
    }
    
    @IBAction
    func verifyCodeBtnAction(_ sender: UIButton) {
        otpView.isHidden = false
        mobileNumView.isHidden = false
        getcodeBtn.isHidden = true
        verifyCodeBtn.isHidden = false
        newCodeBtn.isHidden = false
        
        let mobileNum = mobileField.text ?? ""
        let otpField = otpField.text ?? ""
        
        if mobileNum != "" && otpField != "" {
            
        }
    }
    
    @IBAction
    func newCodeBtnAction(_ sender: UIButton) {
    }
    
}

/*extension OTPAndGeneralInfoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(rgb: 0x353535).withAlphaComponent(0.8) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == residenceTextView {
            if textView.text.isEmpty {
                textView.text = "Resident Address"
                textView.textColor = UIColor(rgb: 0x353535).withAlphaComponent(0.8)
            }
        } else {
            if textView.text.isEmpty {
                textView.text = "Office Address"
                textView.textColor = UIColor(rgb: 0x353535).withAlphaComponent(0.8)
            }
        }
        
    }
}*/

//MARK: - Text Field Delegate Methods
extension OTPAndGeneralInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            textField.resignFirstResponder()
            confirmPassField.becomeFirstResponder()
        } else if textField == confirmPassField {
            textField.resignFirstResponder()
            fullNameField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        enableDisableContinueBtn()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == emailField {
            let maxLength = 50
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == fullNameField {
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
