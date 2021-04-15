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
    //    var fetchCollectionResult: PHFetchResult<PHAssetCollection>!
//    var fetchAssetResult: [PHFetchResult<PHAsset>] = []
    var fetchAssetResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
//    var fetchOptions: PHFetchOptions {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        return fetchOptions
//    }
    
    var scale: CGFloat!
    var itemWidth: CGFloat {
        return UIScreen.main.bounds.width / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.albumListCollectionView.delegate = self
        self.albumListCollectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width / 2)
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
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)

        guard let cameraRollCollection = cameraRoll.firstObject else { return }

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        self.fetchAssetResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
//        let favoriteList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
//        addAlbums(collection: favoriteList)
    }

//    func addAlbums(collection: PHFetchResult<PHAssetCollection>) {
//        for i in 0 ..< collection.count {
//            let collection = collection.object(at: i)
//            self.fetchAssetResult.append(PHAsset.fetchAssets(in: collection, options: fetchOptions))
//        }
//    }
}

extension AlbumListViewController: UICollectionViewDelegate {
    
}

extension AlbumListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchAssetResult.count
        //        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumListCollectionViewCell else {
            return UICollectionViewCell()
        }

        let asset: PHAsset = fetchAssetResult.object(at: indexPath.row)
//
//        guard let asset = fetchAssetResult[indexPath.row].firstObject as? PHAsset else {
//            return UICollectionViewCell()
//        }

        imageManager.requestImage(for: asset, targetSize: CGSize(width: cell.imageView.frame.width, height: 100), contentMode: .default, options: nil) { (image, _) in
            cell.imageView.image = image
        }
        cell.titleLabel.text = "안녕하세요"

        return cell
    }
}

extension AlbumListViewController: UICollectionViewDelegateFlowLayout {

}
