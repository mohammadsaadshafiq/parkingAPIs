//
//  CustomNavBar.swift
//  PrimePark
//
//  Created by Zaira Iqbal on 26/12/2021.
//

import Foundation
import UIKit

class CustomNavBar: UIView {

    let nibName = "CustomNavBar"
    
    @IBOutlet var view : UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }

    func xibSetUp() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomNavBar", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView

    }

}
