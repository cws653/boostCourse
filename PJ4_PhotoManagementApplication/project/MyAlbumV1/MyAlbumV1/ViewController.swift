//
//  ViewController.swift
//  MyAlbumV1
//
//  Created by 최원석 on 2020/08/17.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver {
    
    // 기본 프로퍼티
    @IBOutlet weak var collectionView: UICollectionView!
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier: String = "cell"
    
    // 포토 설정
    
    // 포토라이브러리 변화 여부
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else {
            return
        }
        
        fetchResult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadSections(IndexSet(0...0))
        }
    }
    
    // 컬렉션을 요구하는 함수
    func requestCollection() {
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
    
    // 포토라이브러리 접근제한
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photoAurthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAurthorizationStatus {
        case .authorized:
            print("접근 허가됨")
            self.requestCollection()
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("사용자가 허용함")
                    self.requestCollection()
                    OperationQueue.main.addOperation {
                        self.collectionView.reloadData()
                    }
                case .denied:
                    print("사용자가 불허함")
                default: break
                }
            })
        case .restricted:
            print("접근제한")
        }
        
        PHPhotoLibrary.shared().register(self)
        // Do any additional setup after loading the view.
        
    }
    
    // 컬렉션뷰 섹션별 아이템 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    // 셀 적용 방안
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? CustomCell {
            let asset: PHAsset = fetchResult.object(at: indexPath.item)
            
            imageManager.requestImage(for: asset, targetSize: CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in })
            
            //        cell.imageView.image = UIImage(named: asset)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
        
    }
    
    // 사이즈
    let collectionViewCellWithd = UIScreen.main.bounds.width / 2 - 10
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd)
    }
    
    //위아래 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //        return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd / 2)
    //    }
    
}



