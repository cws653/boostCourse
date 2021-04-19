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
//    var fetchAssetResult: [PHFetchResult<PHAsset>] = []
    var fetchAssetResult: [PHAssetCollection] = []
    var collectionTitle: [String] = []
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var fetchOptions: PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOptions
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        setupCollectionViewItemSize()
        photoAuthorizationStatus()

        PHPhotoLibrary.shared().register(self)
    }

    private func setCollectionView() {
        self.albumListCollectionView.delegate = self
        self.albumListCollectionView.dataSource = self
    }

    private func setupCollectionViewItemSize() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width / 2 - 15)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 1.5 * itemWidth)
        self.albumListCollectionView.collectionViewLayout = flowLayout
    }
    
    private func photoAuthorizationStatus() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근허가")
            self.requestImageCollection()
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("사용자가 허용함")
                    self.requestImageCollection()
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

    private func requestImageCollection() {
        let cameraRollList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let favoriteList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let albumList = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

        addAlbums(collections: cameraRollList)
        addAlbums(collections: favoriteList)
        addAlbums(collections: albumList)

        DispatchQueue.main.async {
            self.albumListCollectionView.reloadData()
        }
    }

    private func addAlbums(collections: PHFetchResult<PHAssetCollection>) {
        collections.enumerateObjects { (collection, index, object) in
//            let photoInAlbum = PHAsset.fetchAssets(in: collection, options: nil)
//            self.fetchAssetResult.append(photoInAlbum)
            self.fetchAssetResult.append(collection)
            self.collectionTitle.append(collection.localizedTitle ?? "nil")
        }
    }
}

extension AlbumListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let assetOfAlbumViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssetOfAlbumViewController") as? AssetOfAlbumViewController else { return }

        let collection = self.fetchAssetResult[indexPath.item]
        assetOfAlbumViewController.photosCollection = collection
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

//        guard let asset = fetchAssetResult[indexPath.item].firstObject else {
//            return UICollectionViewCell()
//        }
        let assets = PHAsset.fetchAssets(in: fetchAssetResult[indexPath.item] , options: nil)

        let asset = assets.firstObject

        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.isSynchronous = true

        cell.titleLabel.text = self.collectionTitle[indexPath.item]
        cell.countLabel.text = String(assets.count)

        if asset == nil {
            cell.imageView.image = nil
        } else {
            self.imageManager.requestImage(for: asset!, targetSize: CGSize(width: asset!.pixelWidth, height: asset!.pixelHeight), contentMode: .aspectFill, options: options) { (image, _) in
                cell.imageView.image = image
                cell.imageView.contentMode = .scaleAspectFill
            }
            return cell
        }
        return cell
    }
}

extension AlbumListViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        fetchAssetResult = []
        collectionTitle = []
        requestImageCollection()
    }
}
