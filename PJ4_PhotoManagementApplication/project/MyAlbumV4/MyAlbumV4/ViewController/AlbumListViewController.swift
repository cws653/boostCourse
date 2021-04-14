//
//  AlbumListVC.swift
//  MyAlbumV4
//
//  Created by 최원석 on 2020/11/14.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos

class AlbumListViewController: UIViewController {
    

    @IBOutlet weak var albumListCollectionView: UICollectionView!
    let cellIdentifier = "albumListCollectionViewCell"
    var fetchCollectionResult: PHFetchResult<PHAssetCollection>!
    var fetchAssetResult: [PHFetchResult<PHAsset>] = []
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    var scale: CGFloat!
    var targetSizeX: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.albumListCollectionView.delegate = self
        self.albumListCollectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10

        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        let itemWidth = (UIScreen.main.bounds.width / 2) - 15

        flowLayout.itemSize = CGSize(width: itemWidth, height: 1.5 * itemWidth)
        self.albumListCollectionView.collectionViewLayout = flowLayout

        self.photoAuthorizationStatus()
    }
    
    func photoAuthorizationStatus() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근허가")
            self.requestImageCollection()
            DispatchQueue.main.async {
                self.albumListCollectionView.reloadData()
            }
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("사용자가 허용함")
                    self.requestImageCollection()
                    DispatchQueue.main.async {
                        self.albumListCollectionView.reloadData()
                    }
                case .denied:
                    print("사용자가 불허함")
                default: break
                }
            })
        case .restricted:
            print("접근 제한")
        default:
            break
        }
    }

    func requestImageCollection() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        self.fetchCollectionResult = cameraRoll

        for i in 0 ..< cameraRoll.count {
            let cameraRollCollection = cameraRoll.object(at: i)
            self.fetchAssetResult.append(PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions))
        }
    }
}

extension AlbumListViewController: UICollectionViewDelegate {
    
}

extension AlbumListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchAssetResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumListCVC
        //        else {
        //            return UICollectionViewCell()
        //        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AlbumListCollectionViewCell
        
//        guard let asset = fetchAssetResult[indexPath.row].firstObject else {
//            return UICollectionViewCell()
//        }
//
//        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (image, _) in
//            cell.imageView.image = image
//        }
        
        return cell
        
        //        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumListCVC {
        //
        //
        //            guard let asset = fetchAssetResult[indexPath.row].firstObject else {
        //                return UICollectionViewCell()
        //            }
        //
        //            imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (image, _) in
        //                cell.imageView.image = image
        //            }
        //
        //            return cell
        //        }
        //        else {
        //            return UICollectionViewCell()
        //        }
    }
}
