//
//  ImageCollectionViewCell.swift
//  movieapp
//
//  Created by Mac on 02/11/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func configureUI(content: Content?) {
        image.backgroundColor = UIColor.green
        
        guard let url = URL(string: content?.imagery?.featuredImg ?? "" ) else {return}
        guard let data = try? Data(contentsOf: url) else { return }
        image.image = UIImage(data: data)
    }
}
