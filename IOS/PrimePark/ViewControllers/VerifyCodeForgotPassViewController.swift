//
//  VerifyCodeForgotPassViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 22/12/2021.
//

import UIKit

class VerifyCodeForgotPassViewController: UIViewController {

    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var getCodeBtn: UIButton!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var verifyCodeBtn: UIButton!
    @IBOutlet weak var changeNumBtn: UIButton!
    @IBOutlet weak var otpField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        otpView.isHidden = true
        mobileView.isHidden = false
        getCodeBtn.isHidden = false
        resendBtn.isHidden = true
        verifyCodeBtn.isHidden = true
        mobileTextField.delegate = self
        otpField.delegate = self
        
        let attr2 = NSAttributedString(string: "Change Number", attributes:
                                        [.underlineStyle: NSUnderlineStyle.single.rawValue])
        changeNumBtn.setAttributedTitle(attr2, for: .normal)
        setupPlaceholderColor("Mobile *", "*")
        setupFieldPlaceholderColor("xxx xxx xxxx", mobileTextField)
        setupFieldPlaceholderColor("xxxx", otpField)
    }
    
    private func setupFieldPlaceholderColor(_ text: String, _ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: text,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xffffff).withAlphaComponent(0.8)])
    }
    
    private func setupPlaceholderColor(_ mainString: String, _ stringToColor: String) {
        let range = (mainString as NSString).range(of: stringToColor)

        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        mobileLabel.attributedText = mutableAttributedString
    }
    
    // MARK: Segues
    private func openForgotPassController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
        vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction
    func getCodeBtnAction(_ sender: UIButton) {
        let mobileNum = mobileTextField.text ?? ""
        
        if mobileNum != "" {
            otpView.isHidden = false
            mobileView.isHidden = false
            getCodeBtn.isHidden = true
            resendBtn.isHidden = false
            verifyCodeBtn.isHidden = false
        } else {
            Utils.showAlert("Failed", "Please enter mobile number", self)
        }
        
    }
    
    @IBAction
    func verifyCodeBtnAction(_ sender: UIButton) {
        
        let mobileNum = mobileTextField.text ?? ""
        let otpField = otpField.text ?? ""
        
        if mobileNum == ""  {
            Utils.showAlert("Failed", "Please enter mobile number", self)
        } else if otpField == "" {
            Utils.showAlert("Failed", "Please enter OTP", self)
        } else  {
            openForgotPassController()
        }
    
    }
    
}

extension VerifyCodeForgotPassViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == otpField {
            let maxLength = 4
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else {
            return true
        }
       
    }
}
