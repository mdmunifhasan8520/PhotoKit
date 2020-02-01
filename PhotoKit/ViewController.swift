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
    @IBOutlet weak var albumNameListCollectionView: UICollectionView!
    
    
    var imageArray = [UIImage]()
    var albumTitle = [String]()
    
    var newimageArray = [UIImage]()

    
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
        let albumList = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
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
        //let result = PHFetchResult<AnyObject>?.self
         var fetchResult: PHFetchResult<PHAsset>!
        albumList.enumerateObjects { (coll, _, _) in
            fetchResult = getAssets(fromCollection: coll)
            print("\(coll.localizedTitle): \(fetchResult.count)")
            let asset = fetchResult.object(at: 0)
            print("asset is \(asset)")
        }
        
        // Now you can:
        // access the count of assets in the PHFetchResult
        print("Z\(fetchResult.count)")
        // get the "real" image
//        PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (image, _) in
//            self.newimageArray.append(image!)
//            }
            // do something with the image
    }
    

}
//photos collection view delegate and data source
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.photosCollectionView {
            return imageArray.count
        } else  {
            return albumTitle.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.photosCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCollectionViewCell
            cell.photosImageView.image = imageArray[indexPath.item]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumNameCell", for: indexPath) as! AlbumNameListCollectionViewCell
            cell.albumNameLabel.text = albumTitle[indexPath.item]
         
            return cell
        }
    }
}

