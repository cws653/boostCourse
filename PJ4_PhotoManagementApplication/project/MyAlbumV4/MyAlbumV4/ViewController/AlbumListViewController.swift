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
    var fetchAssetResult: [PHFetchResult<PHAsset>] = []
    var collectionTitle: [String] = []
//    var fetchAssetResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var fetchOptions: PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOptions
    }
    
//    var scale: CGFloat!
//    var itemWidth: CGFloat {
//        return UIScreen.main.bounds.width / 2
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.albumListCollectionView.delegate = self
        self.albumListCollectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
//        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let itemWidth = (UIScreen.main.bounds.width / 2 - 15)
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
//        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
//
//        guard let cameraRollCollection = cameraRoll.firstObject else { return }
//
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

//        self.fetchAssetResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
        let cameraRollList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let favoriteList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let albumList = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

        addAlbums(collections: cameraRollList)
        addAlbums(collections: favoriteList)
        addAlbums(collections: albumList)
    }

    func addAlbums(collections: PHFetchResult<PHAssetCollection>) {
        collections.enumerateObjects { (collection, index, object) in
            let photoInAlbum = PHAsset.fetchAssets(in: collection, options: nil)
            self.fetchAssetResult.append(photoInAlbum)
            self.collectionTitle.append(collection.localizedTitle ?? "nil")
        }
    }

//    func addAlbums(collection: PHFetchResult<PHAssetCollection>) {
//        for i in 0 ..< collection.count {
//            let collection = collection.object(at: i)
//            self.fetchAssetResult.append(PHAsset.fetchAssets(in: collection, options: fetchOptions))
//        }
//    }
}

extension AlbumListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let assetOfAlbumViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssetOfAlbumViewController") as? AssetOfAlbumViewController else { return }

        guard let collection = fetchAssetResult[indexPath.row] as? PHFetchResult<PHAsset> else { return }
        assetOfAlbumViewController.fetchResult = collection
        navigationController?.pushViewController(assetOfAlbumViewController, animated: true)
    }
}

extension AlbumListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchAssetResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumListCollectionViewCell else {
            return UICollectionViewCell()
        }

//        let asset: PHAsset = fetchAssetResult.object(at: indexPath.row)
//
        guard let asset = fetchAssetResult[indexPath.row].firstObject as? PHAsset else {
            return UICollectionViewCell()
        }

        let options = PHImageRequestOptions()
        options.resizeMode = .fast

        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: options) { (image, _) in
            cell.imageView.image = image
        }
        cell.titleLabel.text = collectionTitle[indexPath.row]

        return cell
    }
}

extension AlbumListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (UIScreen.main.bounds.width / 2 - 15)
        return CGSize(width: itemWidth, height: 1.5 * itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
