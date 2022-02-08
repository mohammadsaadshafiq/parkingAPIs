//
//  LoginViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 17/12/2021.
//
import UIKit
import TTSegmentedControl
import FlagPhoneNumber

class LoginViewController: UIViewController {
    
    // MARK: - Stored Properties
    var loginViewModel: LoginViewModel!
    var iconClick = true
    let email = "zairaiqbal8@gmail.com"
    let pass = "1234"
    
    //MARK: - IBOutlets
    @IBOutlet weak var segmentedCtrl: TTSegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneField: FPNTextField!
    
    //MARK: - ViewController States
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        passwordTextField.delegate = self
        emailTextField.delegate = self
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x5D5D5D)])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x5D5D5D)])
        
        let attr = NSAttributedString(string: "Forgot password?", attributes:
                                        [.underlineStyle: NSUnderlineStyle.single.rawValue])
        forgotPassBtn.setAttributedTitle(attr, for: .normal)
        
        let attr2 = NSAttributedString(string: "Register now", attributes:
                                        [.underlineStyle: NSUnderlineStyle.single.rawValue])
        registerBtn.setAttributedTitle(attr2, for: .normal)
        setupSegmentedControl()
        self.emailView.isHidden = false
        self.mobileView.isHidden = true
        phoneField.setFlag(key: .AE)
        phoneField.delegate = self
        //phoneField.set(phoneNumber: "0600000001")

        // Or directly set the phone number with country code, which will update automatically the flag image
        //phoneField.set(phoneNumber: "+33600000001")
    }
    
    private func setupSegmentedControl() {
        segmentedCtrl.itemTitles = ["Login with Email", "Login with Mobile"]
        segmentedCtrl.selectItemAt(index: 0)
        segmentedCtrl.selectedTextFont = UIFont(name: "Mulish-SemiBold", size: 14)!
        segmentedCtrl.defaultTextFont = UIFont(name: "Mulish-Regular", size: 14)!
        // Do any additional setup after loading the view.
        segmentedCtrl.didSelectItemWith = { (index, title) -> () in
            if index == 0 {
                self.emailView.isHidden = false
                self.mobileView.isHidden = true
            } else {
                self.emailView.isHidden = true
                self.mobileView.isHidden = false
            }
        }
    }

    //MARK: - IBAction
    @IBAction
    func registerBtnAction(_ sender: UIButton) {
        openSignupController()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let pass = passwordTextField.text ?? ""
        
//        if email == "" {
//            Utils.showAlert("Failed", "Please enter your e-mail", self)
//        } else if !Utils.isValidEmail(email) {
//            Utils.showAlert("Failed", "Email address is not valid", self)
//        } else if pass == "" {
//            Utils.showAlert("Failed", "Please enter your password", self)
//        } else if email != self.email || pass != self.pass {
//            Utils.showAlert("Failed", "Email address or Password is in-correct", self)
//        } else {
//            openProfileController()
//        }
        
        openProfileController()
    }
    
    @IBAction func forgotPassBtnAction(_ sender: UIButton) {
        openVerifyForgotPassController()
    }
    
    @IBAction
    func showPassBtnAction(_ sender: UIButton) {
        if(iconClick == true) {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    //MARK: - Private Methods
    private func openSignupController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
    }
    
    private func openVerifyForgotPassController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyCodeForgotPassViewController") as! VerifyCodeForgotPassViewController
        vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
    }
    
    private func openProfileController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
    }
}


//MARK: - Text Field Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == emailTextField {
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

extension LoginViewController: FPNTextFieldDelegate {

   /// The place to present/push the listController if you choosen displayMode = .list
   func fpnDisplayCountryList() {
    
   }

   /// Lets you know when a country is selected
   func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
      print(name, dialCode, code) // Output "France", "+33", "FR"
   }

   /// Lets you know when the phone number is valid or not. Once a phone number is valid, you can get it in severals formats (E164, International, National, RFC3966)
   func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
      if isValid {
         // Do something...
//          textField.getFormattedPhoneNumber(format: .E164);           // Output "+33600000001"
//         textField.getFormattedPhoneNumber(format: .International),  // Output "+33 6 00 00 00 01"
//         textField.getFormattedPhoneNumber(format: .National),       // Output "06 00 00 00 01"
//         textField.getFormattedPhoneNumber(format: .RFC3966),        // Output "tel:+33-6-00-00-00-01"
         textField.getRawPhoneNumber()                               // Output "600000001"
      } else {
         // Do something...
      }
   }
}
