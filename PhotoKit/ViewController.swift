//
//  ViewController.swift
//  PhotoKit
//
//  Created by Md Munif Hasan on 30/1/20.
//  Copyright © 2020 Md Munif Hasan. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    

    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var imageArray = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        grabPhotos()
        

    }
    


    func grabPhotos() {
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions){
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                        image,error in
                        self.imageArray.append(image!)
                    })
                    
                }
            } else {
                print("You got no photo")
                self.photosCollectionView.reloadData()
            }
           
        }
        
    }
    

}
//photos collection view delegate and data source
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCollectionViewCell
       // cell.backgroundColor = UIColor.green
        cell.photosImageView.image = imageArray[indexPath.item]

        return cell
    }
    
    
}

