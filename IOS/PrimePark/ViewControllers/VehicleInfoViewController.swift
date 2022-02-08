//
//  VehicleInfoViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 22/12/2021.
//

import UIKit

protocol VehicleInfoViewControllerDelegate: AnyObject {
    func selectedIndex(_ controller: VehicleInfoViewController, ind: Int)
}

class VehicleInfoViewController: UIViewController {
    
    private var isTruckDriver = false
    private var isElectricVehDriver = false
    weak var delegate: VehicleInfoViewControllerDelegate?
    
    @IBOutlet weak var licenseNumErrLabel: UILabel!
    @IBOutlet weak var vehicleMakeErrorLabel: UILabel!
    @IBOutlet weak var vehicleModelErrorLabel: UILabel!
    @IBOutlet weak var vehicleColorErrorLabel: UILabel!
    @IBOutlet weak var vehicleTypeErrorLabel: UILabel!
    @IBOutlet weak var ElectricalVehicleDriverCheckBox: CheckBox!
    @IBOutlet weak var truckCheckBox: CheckBox!
    @IBOutlet weak var addNewBtn: UIButton!
    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var liscenceNumLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attr2 = NSAttributedString(string: "Add New", attributes:
                                        [.underlineStyle: NSUnderlineStyle.single.rawValue])
        addNewBtn.setAttributedTitle(attr2, for: .normal)
        numberField.delegate = self
        hideErrorLabels()
    }
    
    private func hideErrorLabels() {
        liscenceNumLabel.isHidden = true
        vehicleMakeErrorLabel.isHidden = true
        vehicleTypeErrorLabel.isHidden = true
        vehicleColorErrorLabel.isHidden = true
        vehicleModelErrorLabel.isHidden = true
    }
    
    @IBAction func vehicleTypeBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func vehicleColorBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func vehicleModelBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func vehicleMakeBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func liscncebtnAction(_ sender: UIButton) {
    }
    
    @IBAction func addNewBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        self.delegate?.selectedIndex(self, ind: 2)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.delegate?.selectedIndex(self, ind: 0)
    }
    
    @IBAction func truckDriverBtnAction(_ sender: CheckBox) {
        isTruckDriver = sender.isChecked
    }
    
    @IBAction func electricalVehDriverBtnAction(_ sender: CheckBox) {
        isElectricVehDriver = sender.isChecked
    }
}

extension VehicleInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == numberField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == numberField {
            let maxLength = 10
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else {
            return true
        }
        
    }
}
