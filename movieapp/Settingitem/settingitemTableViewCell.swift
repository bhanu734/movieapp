//
//  settingitemTableViewCell.swift
//  movieapp
//
//  Created by Mac on 05/11/22.
//

import UIKit

class settingitemTableViewCell: UITableViewCell {

    @IBOutlet weak var settingtitle: UILabel!
    @IBOutlet weak var settingcaption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func configureUI(setting: Setting) {
        settingtitle.text = setting.title
        settingcaption.text = setting.caption
    }
}
