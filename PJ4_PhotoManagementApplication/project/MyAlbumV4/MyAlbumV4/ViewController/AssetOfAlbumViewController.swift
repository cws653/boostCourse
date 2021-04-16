//
//  ViewController.swift
//  MyAlbumV4
//
//  Created by 최원석 on 2020/08/20.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos

class AssetOfAlbumViewController: UIViewController {

    @IBOutlet weak var assetOfAlbumCollectionView: UICollectionView!

    let reuseIdentifier = "AssetOfAlbumCollectionViewCell"
    var fetchResult: PHFetchResult<PHAsset>?
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var scale: CGFloat!
    var targetSizeX: CGFloat?

    var rightButton: UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonPressed))
        button.tag = 1
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.rightBarButtonItem = self.rightButton

        assetOfAlbumCollectionView.delegate = self
        assetOfAlbumCollectionView.dataSource = self

        targetSizeX = assetOfAlbumCollectionView.frame.width / 3 - 5
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 7.5
        flowLayout.minimumInteritemSpacing = 2.5
        flowLayout.itemSize = CGSize(width: targetSizeX ?? 0, height: targetSizeX ?? 0)
        assetOfAlbumCollectionView.collectionViewLayout = flowLayout

        self.photoAuthorizationStatus()
    }
    
    func photoAuthorizationStatus() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근허가")
            self.requestCollection()
            DispatchQueue.main.async {
                self.assetOfAlbumCollectionView.reloadData()
            }
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("사용자가 허용함")
                    self.requestCollection()
                    DispatchQueue.main.async {
                        self.assetOfAlbumCollectionView.reloadData()
                    }
                case .denied:
                    print("사용자가 불허함")
                default: break
                }
            })
        case .restricted:
            print("접근 제한")
        case .limited:
            print("")
        @unknown default:
            print("")
        }

        PHPhotoLibrary.shared().register(self)
    }

    func requestCollection() {
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)

        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }

    @objc func trashButtonPressed() {
        print("버튼이 클릭되었습니다.")
    }
}

// MARK: - UICollectionViewDelegate
extension AssetOfAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageZoomViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageZoomViewController") as? ImageZoomViewController else {
            return
        }

        guard let asset = fetchResult?[indexPath.row] as? PHAsset else {
            return
        }

        imageZoomViewController.asset = asset
        navigationController?.pushViewController(imageZoomViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }

}

// MARK: - UICollectionViewDataSource
extension AssetOfAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = assetOfAlbumCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? AssetOfAlbumCollectionViewCell else { return UICollectionViewCell() }

        guard let asset = self.fetchResult?[indexPath.row] else { return UICollectionViewCell() }

        let options = PHImageRequestOptions()
        options.resizeMode = .fast

        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: options) { (image, _) in
            cell.imageView.image = image
        }
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AssetOfAlbumViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        targetSizeX = collectionView.frame.width / 3 - 5
        
        return CGSize(width: targetSizeX ?? 0, height: targetSizeX ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7.5
    }
}

extension AssetOfAlbumViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {

        guard let collection = self.fetchResult else { return }

        guard let changes = changeInstance.changeDetails(for: collection) else { return }

        self.fetchResult = changes.fetchResultAfterChanges

        DispatchQueue.main.async {
            self.assetOfAlbumCollectionView.reloadData()
        }
    }
}
