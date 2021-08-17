//
//  RocketDetailsViewController.swift
//  iOSSpaceXFan
//
//  Created by Rama's_iMac on 15/08/21.
//

import UIKit

var isSelFav = false

class RocketDetailsViewController: UIViewController {
    
    var spaceXItem : SpaceXModel?
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var collectionViewImgs: UICollectionView!
    @IBOutlet weak var favBtn: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }
    

    func setupUI(){
        
        if isSelFav == true {
            favBtn.isSelected = true
        }else{
            favBtn.isSelected = false

        }
        self.collectionViewImgs.delegate = self
        self.collectionViewImgs.dataSource = self
        self.nameLbl.text = spaceXItem?.rocket
        self.descLbl.text = spaceXItem?.details
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RocketDetailsViewController :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return spaceXItem?.links.flickr.original.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let SpaceXCell = collectionViewImgs.dequeueReusableCell(withReuseIdentifier: "RocketDetailsCollectionViewCell", for: indexPath) as! RocketDetailsCollectionViewCell
    
        guard let imgURL = spaceXItem?.links.flickr.original[indexPath.row] else { return SpaceXCell}
        
    SpaceXCell.slideImage.imageFromServerURL(urlString: imgURL, PlaceHolderImage: #imageLiteral(resourceName: "rocketEmpty"))
        
        return SpaceXCell
    }
    
    
    
}

extension RocketDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }

}

class RocketDetailsCollectionViewCell:UICollectionViewCell {
    @IBOutlet weak var slideImage: UIImageView!
    
}



