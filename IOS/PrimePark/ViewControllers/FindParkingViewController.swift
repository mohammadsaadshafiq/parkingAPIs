//
//  FindParkingViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 28/12/2021.
//

import UIKit
import TTSegmentedControl
import DropDown

class FindParkingViewController: UIViewController {

    let dropDown = DropDown()
    let dropDown2 = DropDown()
    private var addresses = [Address]()
    private var sites = [Site]()
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var searchFeildView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var parkingDetailsView: UIView!
    @IBOutlet weak var parkingView: UIView!
    @IBOutlet weak var segmentedControl: TTSegmentedControl!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var allParkingsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        contentStackView.isHidden = true
        setupDummyAddressData()
        setupDummySitesData()
        setupDropdown()
        setupDropdown2()
        setupSegmentedControl()
        crossBtn.isHidden = true
        searchField.addTarget(self, action: #selector(edited), for:UIControl.Event.editingChanged)
    }
    
    @objc
    func edited() {
        crossBtn.isHidden = false
        filterBtn.isHidden = true
        dropDown.show()
    }

    private func setupSegmentedControl() {
        segmentedControl.itemTitles = ["Book by Hour", "Book by Day"]
        segmentedControl.selectItemAt(index: 0)
        // Do any additional setup after loading the view.
        segmentedControl.didSelectItemWith = { (index, title) -> () in
           
        }
    }
    
    private func setupDropdown() {

        // The view to which the drop down will appear on
        dropDown.anchorView = searchFeildView // UIView or UIBarButtonItem
      //  dropDown.direction = .any
        dropDown.bottomOffset = CGPoint(x: 0, y: searchFeildView.bounds.height)
        dropDown.dataSource = ["", "", ""]
        /*** IMPORTANT PART FOR CUSTOM CELLS ***/
        dropDown.cellNib = UINib(nibName: "MenuCell", bundle: nil)
        //dropDown.direction = .bottom
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
           guard let cell = cell as? MenuCell else { return }

           // Setup your custom UI components
            cell.addrLabel.text = self.addresses[index].address
            cell.ratioLabel.text = self.addresses[index].ratio
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            contentStackView.isHidden = false
            parkingView.isHidden = false
            buttonsStackView.isHidden = false
            allParkingsBtn.isHidden = false
            parkingDetailsView.isHidden = true
            detailsBtn.isHidden = true
        }
    }
    
    private func setupDropdown2() {

        // The view to which the drop down will appear on
        dropDown2.anchorView = searchFeildView // UIView or UIBarButtonItem
      //  dropDown.direction = .any
        dropDown2.bottomOffset = CGPoint(x: 0, y: searchFeildView.bounds.height)
        dropDown2.dataSource = ["", "", ""]
        /*** IMPORTANT PART FOR CUSTOM CELLS ***/
        dropDown2.cellNib = UINib(nibName: "OnSiteCell", bundle: nil)
        //dropDown.direction = .bottom
        dropDown2.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
           guard let cell = cell as? OnSiteCell else { return }
            cell.optionLabel.font = UIFont(name: "Mulish-Regular", size: 14)!
            cell.optionLabel.textColor = UIColor(rgb: 0x533467)
           // Setup your custom UI components
            cell.checkboxbtn.isEnabled = self.sites[index].isChecked
            cell.onSiteLabel.text = self.sites[index].parkingType
        }
    }
    
    private func setupDummyAddressData() {
        let add1 = Address(address: "Al Sadd Street", ratio: "189/250")
        let add2 = Address(address: "Al Sadd Street", ratio: "189/251")
        let add3 = Address(address: "Al Sadd Street", ratio: "189/252")
        
        addresses.append(add1)
        addresses.append(add2)
        addresses.append(add3)
    }
    
    private func setupDummySitesData() {
        let site1 = Site(isChecked: true, parkingType: "On-Street Parking")
        let site2 = Site(isChecked: true, parkingType: "Off-Street Parking")
        let site3 = Site(isChecked: true, parkingType: "In-Door Parking")
        
        sites.append(site1)
        sites.append(site2)
        sites.append(site3)
    }
    
    @IBAction func navigationBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        crossBtn.isHidden = true
        filterBtn.isHidden = false
        searchField.text = ""
    }
    
    @IBAction func detailsBtnAction(_ sender: UIButton) {
        parkingView.isHidden = true
        buttonsStackView.isHidden = true
        allParkingsBtn.isHidden = true
        parkingDetailsView.isHidden = false
        detailsBtn.isHidden = false
    }
    
    @IBAction func viewAllParkingsBtnAction(_ sender: UIButton) {
    }

    @IBAction func details2BtnAction(_ sender: UIButton) {
        openReserveParkingController()
    }
    
    @IBAction func minusBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func plusBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func switchBtnAction(_ sender: UIButton) {
        dropDown2.show()
    }
    
    private func openReserveParkingController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReserveParkingViewController") as! ReserveParkingViewController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension FindParkingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dropDown.hide()
    }
}
