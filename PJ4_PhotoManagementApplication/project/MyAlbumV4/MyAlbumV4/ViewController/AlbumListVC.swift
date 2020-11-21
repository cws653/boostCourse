//
//  AlbumListVC.swift
//  MyAlbumV4
//
//  Created by 최원석 on 2020/11/14.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos

class AlbumListVC: UIViewController {
    
    let cellIdentifier = "cell2"
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fetchCollectionResult: PHFetchResult<PHAssetCollection>!
    var fetchAssetResult: [PHFetchResult<PHAsset>] = []
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    var scale: CGFloat!
    var targetSizeX: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(AlbumListCVC.self, forCellWithReuseIdentifier: "cell2")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = UIColor.white
        
        self.photoAuthorizationStatus()
    }
    
    func requestCollection() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        self.fetchCollectionResult = cameraRoll
        
        for i in 0 ..< cameraRoll.count {
            let cameraRollCollection = cameraRoll.object(at: i)
            self.fetchAssetResult.append(PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions))
        }
    }
    
    func photoAuthorizationStatus() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근허가")
            self.requestCollection()
            self.collectionView.reloadData()
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
            print("접근 제한")
        default:
            break
        }
        
        self.collectionView.backgroundColor = .red
        
        //        PHPhotoLibrary.shared().register(self)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension AlbumListVC: UICollectionViewDelegate {
    
}

extension AlbumListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchAssetResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumListCVC
        //        else {
        //            return UICollectionViewCell()
        //        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AlbumListCVC
        
        guard let asset = fetchAssetResult[indexPath.row].firstObject else {
            return UICollectionViewCell()
        }
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (image, _) in
            cell.imageView.image = image
        }
        
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

extension AlbumListVC: UICollectionViewDelegateFlowLayout {
    // 3. 셀의 크기 설정이 이루어진다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        targetSizeX = collectionView.frame.width / 3 - 1
        
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
