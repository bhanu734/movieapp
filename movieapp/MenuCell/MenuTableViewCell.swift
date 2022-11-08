//
//  MenuTableViewCell.swift
//  movieapp
//
//  Created by Mac on 29/10/22.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func configureUI(menu: Menu? ) {
        menuTitle.text = menu?.title
        
        if menu?.isselected ?? false {
            menuTitle.textColor = UIColor.orange
        } else {
            menuTitle.textColor = UIColor.white
        }
    }
    
}
    

