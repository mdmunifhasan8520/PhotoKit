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
    var albumTitle = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        grabPhotos()
        grabAlbumTitle()
        print(albumTitle)
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
    //get album title
    func grabAlbumTitle() {
        let albumList = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: nil)
        
        // you can access the number of albums with
        print(albumList.count)
        for i in 0..<albumList.count {
            let album = albumList.object(at: i)
            // eg. get the name of the album
            albumTitle.append(album.localizedTitle!)
            print(album.localizedTitle!)
            
            }
        // get the assets in a collection
        func getAssets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
            let photosOptions = PHFetchOptions()
            photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            photosOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            
            return PHAsset.fetchAssets(in: collection, options: photosOptions)
        }
        
        // eg.
        albumList.enumerateObjects { (coll, _, _) in
            let result = getAssets(fromCollection: coll)
            print("\(coll.localizedTitle): \(result.count)")
        }
        
        // Now you can:
        // access the count of assets in the PHFetchResult
        //print(result.count)
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

