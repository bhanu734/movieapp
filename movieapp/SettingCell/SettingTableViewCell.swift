//
//  SettingTableViewCell.swift
//  movieapp
//
//  Created by Mac on 29/10/22.
//

import UIKit
protocol SettingTableViewCellDelegate {
    func LoginTapped()
    func RegisterTapped()
    func SettingsTapped()
}

class SettingTableViewCell: UITableViewCell {
    var delegate:  SettingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func LoginTapped() {
        delegate?.LoginTapped()
    }
    
    @IBAction func RegisterTapped() {
        delegate?.RegisterTapped()
    }
    
    @IBAction func SettingsTapped() {
        delegate?.SettingsTapped()
    }
    
}
