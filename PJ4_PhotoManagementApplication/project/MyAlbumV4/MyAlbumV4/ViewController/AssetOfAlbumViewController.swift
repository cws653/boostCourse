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

    enum Mode {
        case view
        case select
    }

    @IBOutlet weak var assetOfAlbumCollectionView: UICollectionView!
    @IBOutlet weak var trashButton: UIBarButtonItem!

    let cellIdentifier = "AssetOfAlbumCollectionViewCell"
    let viewImageSegueIdentifier = "viewImageSegueIdentifier"
    var fetchResult: PHFetchResult<PHAsset>?
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var scale: CGFloat!
    var targetSizeX: CGFloat?

    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                selectBarButton.title = "선택"
                trashButton.isEnabled = false
                assetOfAlbumCollectionView.allowsSelectionDuringEditing = false
            case .select:
                selectBarButton.title = "취소"
                trashButton.isEnabled = true
                assetOfAlbumCollectionView.allowsSelectionDuringEditing = true
            }
        }
    }

    lazy var selectBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectBarButtonClick))
        return button
    }()

    lazy var deleteBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonClick))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        setUpBarButtonItems()

        //        self.photoAuthorizationStatus()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewItemSize()
        // setUpCollectionViewItemSize()를 viewWillLayoutSubviews에서 호출한 이유는
        // collectionview.frame 사이즈를 이 함수에서 호출하기 때문이다.
        // 호출 후 연산에 사용할 수 있다.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let item = sender as! PHAsset

        if segue.identifier == viewImageSegueIdentifier {
            if let viewController = segue.destination as? ImageZoomViewController {
                viewController.asset = item
            }
        }
    }

    private func setCollectionView() {
        assetOfAlbumCollectionView.delegate = self
        assetOfAlbumCollectionView.dataSource = self
    }

    private func setupCollectionViewItemSize() {
        let numberOfItemForRow = 3
        let lineSpacing: CGFloat = 3
        let interItemSpacing: CGFloat = 5
        let width = (Int(assetOfAlbumCollectionView.frame.width) - ((numberOfItemForRow - 1) * Int(interItemSpacing))) / numberOfItemForRow
        let height = width

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.minimumInteritemSpacing = interItemSpacing

        assetOfAlbumCollectionView.collectionViewLayout = flowLayout
    }

    private func setUpBarButtonItems() {
        self.navigationItem.rightBarButtonItem = selectBarButton
        self.trashButton.isEnabled = false
    }

//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//
//        if editing {
//            assetOfAlbumCollectionView.allowsMultipleSelection = true
//            print("Editing Mode Enabled")
//        } else {
//            assetOfAlbumCollectionView.allowsMultipleSelection = false
//            print("Editing Mode Closed")
//        }
//        self.assetOfAlbumCollectionView.reloadData()
//    }

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

    @objc func selectBarButtonClick() {
        print("선택버튼이 클릭되었습니다.")
        mMode = mMode == .view ? .select : .view
    }

    @objc func deleteBarButtonClick() {
        print("삭제버튼이 클릭되었습니다.")
    }
}

// MARK: - UICollectionViewDelegate
extension AssetOfAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("셀이 선택 되었습니다.")
        //
        //        let item = fetchResult?[indexPath.item]
        //        performSegue(withIdentifier: viewImageSegueIdentifier, sender: item)

        switch mMode {
        case .view:
            let item = fetchResult?[indexPath.row]
            performSegue(withIdentifier: viewImageSegueIdentifier, sender: item)
        case .select:
            assetOfAlbumCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }

}

// MARK: - UICollectionViewDataSource
extension AssetOfAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = assetOfAlbumCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AssetOfAlbumCollectionViewCell else { return UICollectionViewCell() }

//        guard let asset = self.fetchResult?[indexPath.row] else { return UICollectionViewCell() }
//
//        let options = PHImageRequestOptions()
//        options.resizeMode = .fast
//
//        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: options) { (image, _) in
//            cell.imageView?.image = image
//        }

        cell.backgroundColor = .orange

        DispatchQueue.main.async {
            collectionView.reloadData()
        }
        return cell
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
