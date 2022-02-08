//
//  SignupViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 21/12/2021.
//

import UIKit
import TTSegmentedControl

class SignupViewController: UIViewController {
    
    private lazy var otpAndGeneralInfoViewController: OTPAndGeneralInfoViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "OTPAndGeneralInfoViewController") as! OTPAndGeneralInfoViewController
        viewController.delegate = self
        return viewController
    }()

    private lazy var vehicleInfoViewController: VehicleInfoViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "VehicleInfoViewController") as! VehicleInfoViewController
        viewController.delegate = self
        return viewController
    }()
    
    private lazy var paymentInfoViewController: PaymentInfoViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PaymentInfoViewController") as! PaymentInfoViewController
        viewController.delegate = self
        return viewController
    }()


    @IBOutlet weak var segmentedCtrl: TTSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: Private methods
    private func setupView() {
        setupSegmentedControl()
        updateView()
    }
    
    private func setupSegmentedControl() {
        segmentedCtrl.itemTitles = ["Personal Details", " Vehicle Details ", "Payments"]
        segmentedCtrl.selectedTextFont = UIFont(name: "Mulish-SemiBold", size: 14)!
        segmentedCtrl.defaultTextFont = UIFont(name: "Mulish-Regular", size: 14)!
        segmentedCtrl.padding = CGSize(width: 5, height: 10)
        
        segmentedCtrl.selectItemAt(index: 0)
        // Do any additional setup after loading the view.
        segmentedCtrl.didSelectItemWith = { (index, title) -> () in
            self.updateView()
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = containerView.bounds
        //viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func updateView() {
        if segmentedCtrl.currentIndex == 0 {
            remove(asChildViewController: vehicleInfoViewController)
            remove(asChildViewController: paymentInfoViewController)
            add(asChildViewController: otpAndGeneralInfoViewController)
        } else if segmentedCtrl.currentIndex == 1 {
            remove(asChildViewController: otpAndGeneralInfoViewController)
            remove(asChildViewController: paymentInfoViewController)
            add(asChildViewController: vehicleInfoViewController)
        } else {
            remove(asChildViewController: otpAndGeneralInfoViewController)
            remove(asChildViewController: vehicleInfoViewController)
            add(asChildViewController: paymentInfoViewController)
        }
    }

}

extension SignupViewController: VehicleInfoViewControllerDelegate {
    
    func selectedIndex(_ controller: VehicleInfoViewController, ind: Int) {
        segmentedCtrl.selectItemAt(index: ind)
        updateView()
    }
}

extension SignupViewController: PaymentInfoViewControllerDelegate {
    
    func selectedIndex(_ controller: PaymentInfoViewController, ind: Int) {
        segmentedCtrl.selectItemAt(index: ind)
        updateView()
    }
}

extension SignupViewController: OTPAndGeneralInfoViewControllerDelegate {
    
    func selectedIndex(_ controller: OTPAndGeneralInfoViewController, ind: Int) {
        segmentedCtrl.selectItemAt(index: ind)
        updateView()
    }
}
