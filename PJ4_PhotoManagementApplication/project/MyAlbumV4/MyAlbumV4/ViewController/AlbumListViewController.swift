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

    let cellIdentifier = "albumListCollectionViewCell"

    var fetchAssets: [PHFetchResult<PHAsset>] = []
    var fetchCollections: [PHAssetCollection] = []
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    @IBOutlet weak var albumListCollectionView: UICollectionView!

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
            DispatchQueue.global().async {
                self.requestImageCollection()
                DispatchQueue.main.async {
                    self.albumListCollectionView.reloadData()
                }
            }
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("사용자가 허용함")
                    DispatchQueue.global().async {
                        self.requestImageCollection()
                        DispatchQueue.main.async {
                            self.albumListCollectionView.reloadData()
                        }
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

    private func requestImageCollection() {
        fetchCollections.removeAll()
        fetchAssets.removeAll()

        let cameraRollList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let favoriteList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let albumList = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        for i in 0 ..< cameraRollList.count {
            let assets = PHAsset.fetchAssets(in: cameraRollList[i], options: fetchOptions)

            if assets.count > 0 {
                self.fetchCollections.append(cameraRollList[i])
                self.fetchAssets.append(assets)
            }
        }

        for i in 0 ..< favoriteList.count {
            let assets = PHAsset.fetchAssets(in: favoriteList[i], options: fetchOptions)

            if assets.count > 0 {
                fetchCollections.append(favoriteList[i])
                fetchAssets.append(assets)
            }
        }

        for i in 0 ..< albumList.count {
            let assets = PHAsset.fetchAssets(in: albumList[i], options: fetchOptions)

            if assets.count > 0 {
                fetchCollections.append(albumList[i])
                fetchAssets.append(assets)
            }
        }
    }
}

extension AlbumListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let assetOfAlbumViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssetOfAlbumViewController") as? AssetOfAlbumViewController else { return }

        assetOfAlbumViewController.fetchCollection = self.fetchCollections[indexPath.item]
        assetOfAlbumViewController.fetchAsset = self.fetchAssets[indexPath.item]
        navigationController?.pushViewController(assetOfAlbumViewController, animated: true)
    }
}

extension AlbumListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumListCollectionViewCell else {
            return UICollectionViewCell()
        }

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let requestOperation = OperationQueue()
        requestOperation.addOperation {
            guard let asset = self.fetchAssets[indexPath.item].firstObject else { return }
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil) { (image, _) in
                OperationQueue.main.addOperation {
                    cell.imageView.image = image
                }
            }
        }

        cell.titleLabel.text = fetchCollections[indexPath.item].localizedTitle
        cell.countLabel.text = String(fetchAssets[indexPath.item].count)

        return cell
    }
}

extension AlbumListViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        let requestOperation = OperationQueue()
        DispatchQueue.global().async {
            self.requestImageCollection()
            DispatchQueue.main.async {
                self.albumListCollectionView.reloadData()
            }
        }
    }
}
