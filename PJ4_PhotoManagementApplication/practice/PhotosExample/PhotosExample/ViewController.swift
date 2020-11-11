//
//  ViewController.swift
//  PhotosExample
//
//  Created by 최원석 on 2020/08/04.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PHPhotoLibraryChangeObserver {
    
    @IBOutlet weak var tableView: UITableView!
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier: String = "cell"
    
    // 리프레쉬 버튼 사용
    @IBAction func touchUpRefreshButton(_ sender: UIBarButtonItem) {
        self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
    }
    
    // 테이블뷰 셀 수정 가능 여부
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 테이블뷰 셀 수정 스타일
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let asset: PHAsset = self.fetchResult[indexPath.row]
            
            PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.deleteAssets([asset] as NSArray)}, completionHandler: nil)
        }
    }
    
    // 포토라이브러리 변화 여부
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else {
            return
        }
        
        fetchResult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
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
        
        self.tableView.dataSource = self
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근 허가됨")
            self.requestCollection()
            self.tableView.reloadData()
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
                        self.tableView.reloadData()
                    }
                case .denied:
                    print("사용자가 불허함")
                default: break
                }
            })
        case .restricted:
            print("접근 제한")
        }
        
        PHPhotoLibrary.shared().register(self)
    }
    
    // 테이블뷰 섹션별 행 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    // 셀 적용 방안
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let asset: PHAsset = fetchResult.object(at: indexPath.row)
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 30, height: 30), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in cell.imageView?.image = image
            
        })
        return cell
    }
    
    // 다음 컨트롤뷰 적용
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: ImageZoomViewController = segue.destination as? ImageZoomViewController else {
            return
        }
        
        guard let cell: UITableViewCell = sender as? UITableViewCell else {
            return
        }
        
        guard let index: IndexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        nextViewController.asset = self.fetchResult[index.row]
    }
}

