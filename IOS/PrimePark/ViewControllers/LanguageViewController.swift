//
//  LanguageViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 20/12/2021.
//

import UIKit
import TTSegmentedControl

class LanguageViewController: UIViewController {

    @IBOutlet weak var segmentCtrl: TTSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        segmentCtrl.itemTitles = ["English", "عربى"]
        segmentCtrl.selectItemAt(index: 0)
        segmentCtrl.selectedTextFont = UIFont(name: "Mulish-SemiBold", size: 14)!
        segmentCtrl.defaultTextFont = UIFont(name: "Mulish-Regular", size: 14)!
        // Do any additional setup after loading the view.
        segmentCtrl.didSelectItemWith = { (index, title) -> () in
        }
    }
    
    private func openLoginController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction
    func nextBtnAction(_ sender: UIButton) {
        openLoginController()
    }
    
}
