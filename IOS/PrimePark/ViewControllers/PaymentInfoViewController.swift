//
//  PaymentInfoViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 22/12/2021.
//

import UIKit

protocol PaymentInfoViewControllerDelegate: AnyObject {
    func selectedIndex(_ controller: PaymentInfoViewController, ind: Int)
}

class PaymentInfoViewController: UIViewController {
    
    weak var delegate: PaymentInfoViewControllerDelegate?
    private var cardisChecked = false
    private var isSubmit = false
    
    @IBOutlet weak var saveCardStackView: UIStackView!
    @IBOutlet weak var expiryView: UIStackView!
    @IBOutlet weak var cardNumView: UIView!
    @IBOutlet weak var cardNameView: UIView!
    @IBOutlet weak var expiryField: UITextField!
    @IBOutlet weak var cardNumField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var cardNameField: UITextField!
    @IBOutlet weak var paypalView: UIView!
    @IBOutlet weak var debitCardView: UIView!
    @IBOutlet weak var mobileWalletView: UIView!
    @IBOutlet weak var creditCardView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var saveCardCheckbox: CheckBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardNameView.isHidden = true
        cardNumView.isHidden = true
        expiryView.isHidden = true
        saveCardStackView.isHidden = true
        
        cardNameField.delegate = self
        cardNumField.delegate = self
        expiryField.delegate = self
        cvvField.delegate = self
        
        setupPlaceholderColor("Name on Card", "Name on Card", cardNameField)
        setupPlaceholderColor("Card Number", "Card Number", cardNumField)
        setupPlaceholderColor("Expiry", "Expiry", expiryField)
        setupPlaceholderColor("CVV", "CVV", cvvField)
    }
    
    // MARK: Private methods
    private func setupPlaceholderColor(_ mainString: String, _ stringToColor: String, _ textField: UITextField) {
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: mainString)
        attributedString.setColorForText(textForAttribute: stringToColor, withColor: UIColor(rgb: 0x353535).withAlphaComponent(0.8))
        textField.attributedPlaceholder = attributedString
    }
    
    // MARK: Actions
    @IBAction func nextBtnAction(_ sender: UIButton) {
        isSubmit = true
        nextBtn.setTitle("Submit", for: .normal)
        cardNameView.isHidden = false
        cardNumView.isHidden = false
        expiryView.isHidden = false
        saveCardStackView.isHidden = false
        
        if nextBtn.titleLabel?.text == "Submit" {
            let cardName = cardNameField.text ?? ""
            let cardNum = cardNumField.text ?? ""
            let expiry = expiryField.text ?? ""
            let cvv = cvvField.text ?? ""
            
            if cardName != "" && cardNum != "" && expiry != "" && cvv != "" {
                
            }
        }
        
        if cardisChecked {
            
        }
        
    }
    
    @IBAction func paymentBtnAction(_ sender: UIButton) {
        mobileWalletView.backgroundColor = UIColor(rgb: 0xFAD000)
        creditCardView.backgroundColor = UIColor(rgb: 0xFDEC99)
        debitCardView.backgroundColor = UIColor(rgb: 0xFDEC99)
        paypalView.backgroundColor = UIColor(rgb: 0xFDEC99)
    }
    
    @IBAction func creditBtnAction(_ sender: UIButton) {
        mobileWalletView.backgroundColor = UIColor(rgb: 0xFDEC99)
        creditCardView.backgroundColor = UIColor(rgb: 0xFAD000)
        debitCardView.backgroundColor = UIColor(rgb: 0xFDEC99)
        paypalView.backgroundColor = UIColor(rgb: 0xFDEC99)
    }
    
    @IBAction func debitBtnAction(_ sender: UIButton) {
        mobileWalletView.backgroundColor = UIColor(rgb: 0xFDEC99)
        creditCardView.backgroundColor = UIColor(rgb: 0xFDEC99)
        debitCardView.backgroundColor = UIColor(rgb: 0xFAD000)
        paypalView.backgroundColor = UIColor(rgb: 0xFDEC99)
    }
    
    @IBAction func paypalBtnAction(_ sender: UIButton) {
        mobileWalletView.backgroundColor = UIColor(rgb: 0xFDEC99)
        creditCardView.backgroundColor = UIColor(rgb: 0xFDEC99)
        debitCardView.backgroundColor = UIColor(rgb: 0xFDEC99)
        paypalView.backgroundColor = UIColor(rgb: 0xFAD000)
    }
    
    @IBAction func saveCardBtn(_ sender: CheckBox) {
        cardisChecked = sender.isChecked
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        delegate?.selectedIndex(self, ind: 1)
    }
    
}

extension PaymentInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        
        if textField == cvvField {
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

