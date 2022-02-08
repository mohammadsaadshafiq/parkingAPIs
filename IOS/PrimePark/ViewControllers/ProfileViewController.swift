//
//  ProfileViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 23/12/2021.
//

import UIKit

class ProfileViewController: UIViewController {

    private var isTruckDriver = false
    private var isElectricVehicleDriver = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mobileNumLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var expiryField: UITextField!
    @IBOutlet weak var cardNumField: UITextField!
    @IBOutlet weak var cardNameField: UITextField!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var personalMinSection: UIView!
    @IBOutlet weak var personalOpenSection: UIView!
    @IBOutlet weak var vehicleMinSec: UIView!
    @IBOutlet weak var vehicleOpenSection: UIView!
    @IBOutlet weak var paymentsMinSection: UIView!
    @IBOutlet weak var paymentsOpenSection: UIView!
    @IBOutlet weak var residenceTextView: UITextView!
    @IBOutlet weak var mobNumField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var officeAddressTextView: UITextView!
    @IBOutlet weak var electricVehicleDriverCheckbox: CheckBox!
    @IBOutlet weak var truckDriverCheckbox: CheckBox!
    @IBOutlet weak var vehMakeField: UITextField!
    @IBOutlet weak var vehModelField: UITextField!
    @IBOutlet weak var vehColorField: UITextField!
    @IBOutlet weak var vehTypeField: UITextField!
    @IBOutlet weak var licenseNumField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        personalOpenSection.isHidden = true
        vehicleOpenSection.isHidden = true
        paymentsOpenSection.isHidden = true
        
        setupDelegates()
        setupPlaceholderColor("Full Name *", "*", "Full Name", fullNameLabel)
        setupPlaceholderColor("E-mail *", "*", "E-mail", emailLabel)
        setupPlaceholderColor("Mobile Number *", "*", "Mobile Number", mobileNumLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //contentView.roundCorners(corners: [.topLeft, .topRight], radius: 12)
    }
    
    override var prefersStatusBarHidden: Bool {
       return true
    }
    
    // MARK: Private Methods
    private func setupDelegates() {
        fullNameField.delegate = self
        emailField.delegate = self
        mobNumField.delegate = self
        residenceTextView.delegate = self
        officeAddressTextView.delegate = self
        vehTypeField.delegate = self
        vehColorField.delegate = self
        vehModelField.delegate = self
        vehMakeField.delegate = self
        licenseNumField.delegate = self
        cardNumField.delegate = self
        cardNameField.delegate = self
        expiryField.delegate = self
        cvvField.delegate = self
    }
    
    private func setupPlaceholderColor(_ mainString: String, _ stringToColor: String, _ secondToColor: String, _ label: UILabel) {
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: mainString)
        attributedString.setColorForText(textForAttribute: stringToColor, withColor: UIColor.red)
        attributedString.setColorForText(textForAttribute: secondToColor, withColor: UIColor(rgb: 0x353535).withAlphaComponent(0.8))
        label.attributedText = attributedString
    }
    
    private func openFindParkingController() {
        let storyboard = UIStoryboard(name: "Parking", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FindParkingViewController") as! FindParkingViewController
        vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction
    func findParkingBtnAction(_ sender: UIButton) {
        openFindParkingController()
    }
    
    @IBAction
    func addNewVehicleBtnAction(_ sender: UIButton) {
    }
    
    @IBAction
    func personalDetailsOpenBtnAction(_ sender: UIButton) {
        personalMinSection.isHidden = true
        personalOpenSection.isHidden = false
    }
    
    @IBAction
    func personalDetailsCloseBtnAction(_ sender: UIButton) {
        personalMinSection.isHidden = false
        personalOpenSection.isHidden = true
    }
    
    @IBAction
    func vehicleSectionOpenBtnAction(_ sender: UIButton) {
        vehicleMinSec.isHidden = true
        vehicleOpenSection.isHidden = false
    }
    
    @IBAction
    func vehicleSectionCloseBtnAction(_ sender: UIButton) {
        vehicleMinSec.isHidden = false
        vehicleOpenSection.isHidden = true
    }
    
    @IBAction
    func paymentsOpenBtnAction(_ sender: UIButton) {
        paymentsMinSection.isHidden = true
        paymentsOpenSection.isHidden = false
    }
    
    @IBAction
    func paymentsCloseBtnAction(_ sender: UIButton) {
        paymentsMinSection.isHidden = false
        paymentsOpenSection.isHidden = true
    }
    
    @IBAction
    func truckDriverBtnAction(_ sender: CheckBox) {
        isTruckDriver = sender.isChecked
    }
    
    @IBAction
    func electricDriverBtnAction(_ sender: CheckBox) {
        isElectricVehicleDriver = sender.isChecked
    }
    
    @IBAction
    func removeCreditCardBtnAction(_ sender: UIButton) {
    }
    
    @IBAction
    func liscenseBtnAction(_ sender: UIButton) {
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameField {
            textField.resignFirstResponder()
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            textField.resignFirstResponder()
            mobNumField.becomeFirstResponder()
        } else if textField == mobNumField {
            textField.resignFirstResponder()
        }
        
        if textField == vehTypeField {
            textField.resignFirstResponder()
            vehColorField.becomeFirstResponder()
        } else if textField == vehColorField {
            textField.resignFirstResponder()
            vehModelField.becomeFirstResponder()
        } else if textField == vehModelField {
            textField.resignFirstResponder()
            vehMakeField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        if textField == vehTypeField {
            textField.resignFirstResponder()
            vehColorField.becomeFirstResponder()
        } else if textField == vehColorField {
            textField.resignFirstResponder()
            vehModelField.becomeFirstResponder()
        } else if textField == vehModelField {
            textField.resignFirstResponder()
            vehMakeField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        if textField == cardNameField {
            textField.resignFirstResponder()
            cardNumField.becomeFirstResponder()
        } else if textField == cardNumField {
            textField.resignFirstResponder()
            expiryField.becomeFirstResponder()
        } else if textField == expiryField {
            textField.resignFirstResponder()
            cvvField.becomeFirstResponder()
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

extension ProfileViewController: UITextViewDelegate {
    
}


