//
//  ViewController.swift
//  MyAlbumV4
//
//  Created by 최원석 on 2020/08/20.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos

enum Mode {
    case view
    case select
}

class AssetOfAlbumViewController: UIViewController {

    @IBOutlet weak var assetOfAlbumCollectionView: UICollectionView!
    @IBOutlet weak var trashButton: UIBarButtonItem!

    let cellIdentifier = "AssetOfAlbumCollectionViewCell"
    let viewImageSegueIdentifier = "viewImageSegueIdentifier"
    var fetchResult: PHFetchResult<PHAsset>?
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var scale: CGFloat!
    var targetSizeX: CGFloat?
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                for (key, value) in dictionarySelectedIndexPath {
                    if value {
                        assetOfAlbumCollectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndexPath.removeAll()

                selectBarButton.title = "선택"
                trashButton.isEnabled = false
                assetOfAlbumCollectionView.allowsMultipleSelection = false
            case .select:
                selectBarButton.title = "취소"
                trashButton.isEnabled = true
                assetOfAlbumCollectionView.allowsMultipleSelection = true
            }
        }
    }

    lazy var selectBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectBarButtonClick(_:)))
        return button
    }()

    @IBAction func deleteBarButtonClick(_ sender: UIBarButtonItem) {
        print("삭제버튼이 클릭되었습니다.")
        var deleteNeededIndexPaths: [IndexPath] = []
        for (key, value) in dictionarySelectedIndexPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }

        let assetArray: NSMutableArray = NSMutableArray()
        for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
            guard let asset = self.fetchResult?.object(at: i.item) else { return }
            assetArray.addObjects(from: [asset])
        }

        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(assetArray)})
        assetOfAlbumCollectionView.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndexPath.removeAll()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        setUpBarButtonItems()

        PHPhotoLibrary.shared().register(self)
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

    @objc func selectBarButtonClick(_ sender: UIBarButtonItem) {
        print(mMode)
        mMode = mMode == .view ? .select : .view
    }
}

// MARK: - UICollectionViewDelegate
extension AssetOfAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("셀이 선택 되었습니다.")

        switch mMode {
        case .view:
            assetOfAlbumCollectionView.deselectItem(at: indexPath, animated: true)
            let item = fetchResult?[indexPath.item]
            performSegue(withIdentifier: viewImageSegueIdentifier, sender: item)
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select {
            dictionarySelectedIndexPath[indexPath] = false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AssetOfAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = assetOfAlbumCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AssetOfAlbumCollectionViewCell else { return UICollectionViewCell() }

        guard let asset = self.fetchResult?[indexPath.item] else { return UICollectionViewCell() }

        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.isSynchronous = true

        self.imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: options) { (image, _) in
            cell.imageView?.image = image
            cell.imageView?.contentMode = .scaleAspectFill
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
