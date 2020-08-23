//
//  ViewController.swift
//  MyAlbumV3
//
//  Created by 최원석 on 2020/08/19.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "cell"
    @IBOutlet weak var burstAlbumCollectionView: UICollectionView!
    
    var burstImages: PHFetchResult<PHAsset>!
    var burstAlbum: PHFetchResult<PHAssetCollection>!
    var burst: PHFetchResult<PHCollectionList>!
    var options = PHFetchOptions()
    let imageManager = PHCachingImageManager()
    
    var scale: CGFloat!
    var targetSizeX: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // collection view 설정
        burstAlbumCollectionView.delegate = self
        burstAlbumCollectionView.dataSource = self
        // UX 설정
        // 1. collection view
        burstAlbumCollectionView.backgroundColor = UIColor.white
        
        // 화면의 가로 사이즈를 구한다.
        // 화면이 landscape 하면 세로 사이즈를 구한다.
        scale = UIScreen.main.scale
        // 화면의 좁은 쪽을 기준으로 3등분한다.
        targetSizeX = UIScreen.main.bounds.width * scale / 3
        print("targetSizeX = \(targetSizeX)")
        
        options.includeAllBurstAssets = true
        
        burstAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: options)
        print("assetCollection.count = \(burstAlbum.count)")
        
        let collection = burstAlbum.firstObject as! PHAssetCollection
        burstImages = PHAsset.fetchAssets(in: collection, options: options)
        
        
        //        if let collection = burstAlbum.firstObject {
        //            burstImages = PHAsset.fetchKeyAssets(in: collection, options: options)
        //        } else {
        //            return
        //        }
    }
    
    // collection view가 처리되는 과정은 아래 메소드의 순서대로이다.
    // 1. numberOfSectionsCollectionView 가 가장 먼저 실행되어 section의 개수를 파악한다.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("numberOfSectionInCollectionView = 1")
        return 1
    }
    
    // 2. numberOfItemsInSection가 실행되어 Section당 Item의 개수를 파악한다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        print("numberOfItemInSection = \(burstImages.count)")
        return burstImages?.count ?? 0
    }
    
    // 3. 셀의 크기 설정이 이루어진다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 사진앱과 가장 비슷한 UX를 제공하려면 minimumInteritemSpacingForSectionAtIndex, minimumLineSpacingForSectionAtIndex 둘 다 1로 설정하는 것이다.
        // 이 크기를 감안해서 cell의 크기를 설정해 주어야 한다.
        // 만약 spacing을 고려하지 않고 cell의 크기를 설정하게 되어 미묘하게 cell 크기가 가로 크기를 넘길 경우 이쁘지 않은 레이아웃을 보게 될 것이다.
        // 그러므로 최종 cell의 크기는 spacing 값을 참조하여 빼주도록 한다.
        targetSizeX = burstAlbumCollectionView.frame.width / 3 - 1
        print("cell 크기 설정 - targetsizex = \(targetSizeX)")
        
        return CGSize(width: targetSizeX, height: targetSizeX)
    }
    
    // 4. cell 내부 아이템의 최소 스페이싱을 설정한다. 셀간의 가로 간격이라고 생각하면 된다.
    // 자세한 내용은 애플문서나 부스트코스를 보자.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        print("minimumInteritemSpacingForSectionAtIndex 설정")
        return 1 as CGFloat
    }
    
    // 5. cell 간 라인 스페이싱을 설정한다. 셀간의 세로 간격이라고 생각하면 된다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print("minimumLineSpacingForSectionAtIndex 설정")
        return 1 as CGFloat
    }
    
    // 셀의 내용을 설정하는 메소드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FirstCollectionViewCell {
            
            cell.imageManager = imageManager
            print("cell 내용 설정 - targetSizeX = \(targetSizeX)")
            cell.targetSizeX = targetSizeX
            cell.imageAsset = burstImages[indexPath.item] as? PHAsset
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    // 셀이 선택되었을 때를 설정하는 메소드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FirstCollectionViewCell {
            
            cell.layer.borderColor = UIColor.yellow.cgColor
            cell.layer.borderWidth = 5
        }
        let burstIdentifier = burstImages[indexPath.item].burstIdentifier
        performSegue(withIdentifier: "BurstImageSegue", sender: burstIdentifier)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "BurstImageSegue" {
            if let burstImageVC = segue.destinationViewController as? BurstImageVC {
                if let burstIdentifier = sender as? String {
                    burstImageVC.burstIdentifier = burstIdentifier
                }
            }
        }
        // Pass the selected object to the new view controller.
    }
    
}

