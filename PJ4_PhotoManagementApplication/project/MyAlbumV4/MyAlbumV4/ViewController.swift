//
//  ViewController.swift
//  MyAlbumV4
//
//  Created by 최원석 on 2020/08/20.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos

class AssetOfAlbumVC: UIViewController {
    
    let reuseIdentifier = "cell"
    @IBOutlet weak var firstCollectionView: UICollectionView!
    
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    var scale: CGFloat!
    var targetSizeX: CGFloat!
    
    func requestCollection(){
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        guard  let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
        
        //        let collection = burstAlbum.firstObject as! PHAssetCollection
        //               burstImages = PHAsset.fetchAssets(in: collection, options: options)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // collectionview 설정
        self.firstCollectionView.delegate = self
        self.firstCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        self.firstCollectionView.collectionViewLayout = layout
        // collectionview UX 설정
        firstCollectionView.backgroundColor = UIColor.white
        
        // 접근허가
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근허가")
            self.requestCollection()
            self.firstCollectionView.reloadData()
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
                        self.firstCollectionView.reloadData()
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
        
        self.firstCollectionView.backgroundColor = .red
        
//        PHPhotoLibrary.shared().register(self)
    }

    
    // 다음 컨트롤뷰 적용
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextViewController: ImageZoomViewController = segue.destination as? ImageZoomViewController else {
            return
        }
        
        guard let cell: UICollectionViewCell = sender as? UICollectionViewCell else {
            return
        }
        
        guard let index: IndexPath = self.firstCollectionView.indexPath(for: cell) else {
            return
        }
        
        nextViewController.asset = self.fetchResult[index.item]
    }
    
}

// MARK: - UICollectionViewDelegate
extension AssetOfAlbumVC: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension AssetOfAlbumVC: UICollectionViewDataSource {
    // collection view가 처리되는 과정은 아래 메소드의 순서대로이다.
    // 1. numberOfSectionsCollectionView 가 가장 먼저 실행되어 section의 개수를 파악한다.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

     // 2. numberOfItemsInSection가 실행되어 Section당 Item의 개수를 파악한다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }

    // 6. 셀의 내용을 설정하는 메소드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FirstCollectionViewCell {

            cell.imageManager = imageManager
            //cell.targetSizeX = targetSizeX
            cell.imageAsset = fetchResult[indexPath.item]

            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
}

// MARK: -
extension AssetOfAlbumVC: UICollectionViewDelegateFlowLayout {
    
    // 3. 셀의 크기 설정이 이루어진다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        targetSizeX = firstCollectionView.frame.width / 3 - 1
        
        return CGSize(width: targetSizeX, height: targetSizeX)
    }
    
    // 4. cell 내부 아이템의 최소 스페이싱을 설정한다. 셀간의 가로 간격이라고 생각하면 된다.
    // 자세한 내용은 애플문서나 부스트코스를 보자.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 5. cell 간 라인 스페이싱을 설정한다. 셀간의 세로 간격이라고 생각하면 된다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
