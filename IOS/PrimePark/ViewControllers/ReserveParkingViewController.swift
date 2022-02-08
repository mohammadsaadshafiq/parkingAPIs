//
//  ReserveParkingViewController.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 29/12/2021.
//

import UIKit
import TTSegmentedControl

class ReserveParkingViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mySpotLabel: UILabel!
    @IBOutlet weak var spotLeftLabel: UILabel!
    @IBOutlet weak var dayStackView: UIStackView!
    @IBOutlet weak var hourStackView: UIStackView!
    @IBOutlet weak var segmentedControl: TTSegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //contentView.roundCorners(corners: [.topLeft, .topRight], radius: 12)
    }
    
    private func setupSegmentedControl() {
        segmentedControl.itemTitles = ["Book by Hour", "Book by Day"]
        segmentedControl.selectItemAt(index: 0)
        hourStackView.isHidden = false
        dayStackView.isHidden = true
        contentViewHeightConstraint.constant = 480
        // Do any additional setup after loading the view.
        segmentedControl.didSelectItemWith = { (index, title) -> () in
            if index == 0 {
                self.hourStackView.isHidden = false
                self.dayStackView.isHidden = true
                self.contentViewHeightConstraint.constant = 480
            } else {
                self.hourStackView.isHidden = true
                self.dayStackView.isHidden = false
                self.contentViewHeightConstraint.constant = 548
            }
        }
    }
    
    @IBAction
    func callBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func saveParkingBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func reserveBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func calculateBtnAction(_ sender: UIButton) {
    }
}
