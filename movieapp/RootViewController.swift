//
//  RootViewController.swift
//  movieapp
//
//  Created by Mac on 27/10/22.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var homeview : UIView!
    @IBOutlet weak var homeviewwidth : NSLayoutConstraint!
    @IBOutlet weak var menuview : UIView!
    @IBOutlet weak var menuleading : NSLayoutConstraint!

    var isMenuOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeviewwidth.constant = UIScreen.main.bounds.width
        menuleading.constant = -200

    }
    

    @IBAction func menuTapped () {
        if isMenuOpen {
            menuleading.constant = -200
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.view.layoutIfNeeded()
            } completion: { bool in
                self.isMenuOpen = false
        }
        }
        else {
            menuleading.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.view.layoutIfNeeded()
            } completion: { bool in
                self.isMenuOpen = true
            }
        }
        

        
    }

}
