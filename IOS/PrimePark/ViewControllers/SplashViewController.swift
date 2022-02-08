//
//  SplashViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 20/12/2021.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction
    func getStartedBtnAction(_ sender: UIButton) {
        openLanguageController()
    }
    
    private func openLanguageController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
    }
    
}
