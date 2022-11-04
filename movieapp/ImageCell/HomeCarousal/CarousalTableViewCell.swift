//
//  CarousalTableViewCell.swift
//  movieapp
//
//  Created by Mac on 02/11/22.
//

import UIKit

class CarousalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var carousalTitle: UILabel!
    @IBOutlet weak var carousalCollectionview: UICollectionView!
    
    var playlist : Playlist?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        carousalCollectionview.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        carousalCollectionview.delegate = self
        carousalCollectionview.dataSource = self
    }
    func ConfigUI(playlist: Playlist?) {
        if let playlist = playlist{
            self.playlist = playlist
            carousalTitle.text = playlist.title
            
            carousalCollectionview.reloadData()
        }
    }
}

extension CarousalTableViewCell: UICollectionViewDelegate{
    
}

extension CarousalTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlist?.content?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = carousalCollectionview.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell{
            cell.configureUI(content: playlist?.content?[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}

extension CarousalTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: 150, height: 150   )
        
    }
}
