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
    @IBOutlet weak var trashBarButton: UIBarButtonItem!
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var dateSortBarButton: UIBarButtonItem!

    let cellIdentifier = "AssetOfAlbumCollectionViewCell"
    let viewImageSegueIdentifier = "viewImageSegueIdentifier"

    var fetchAsset: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    var fetchCollection: PHAssetCollection = PHAssetCollection()
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    var selectImage: [Int: PHAsset] = [:]
    var selectMode: SelectMode = .select
    var dateSortMode: DateSortMode = .latest
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height

    lazy var selectBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectBarButtonClick(_:)))
        return button
    }()

    @IBAction func deleteBarButtonClick(_ sender: UIBarButtonItem) {
        PHPhotoLibrary.shared().performChanges {
            let asset = Array(self.selectImage.values)
            PHAssetChangeRequest.deleteAssets(asset as NSArray)
        } completionHandler: { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.navigationItem.title = self.fetchCollection.localizedTitle
                    self.selectBarButton.title = "선택"
                    self.dateSortBarButton.isEnabled = true
                    self.shareBarButton.isEnabled = false
                    self.trashBarButton.isEnabled = false
                    self.selectImage.removeAll()
                    self.selectMode = .select
                    self.assetOfAlbumCollectionView.reloadData()
                }
            } else {
                print("\(String(describing: error))")
            }
        }
    }

    @IBAction func shareBarButtonClick(_ sender: UIBarButtonItem) {
        DispatchQueue.global().async {
            let asset: [PHAsset] = Array(self.selectImage.values)
            var imageShare: [UIImage] = []
            for i in 0..<asset.count {
                self.imageManager.requestImage(for: asset[i], targetSize: CGSize(width: self.width, height: self.height), contentMode: .aspectFill, options: nil) { (image, _) in
                    if let image = image {
                        DispatchQueue.main.async {
                            imageShare.append(image)

                            let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
                            self.present(activityViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

    @IBAction func dateSortBarButtonClick(_ sender: UIBarButtonItem) {
        let fetchOptions = PHFetchOptions()
        switch dateSortMode {
        case .latest:
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            self.fetchAsset = PHAsset.fetchAssets(in: fetchCollection, options: fetchOptions)
            DispatchQueue.main.async {
                self.assetOfAlbumCollectionView.reloadData()
            }
            self.dateSortBarButton.title = "과거순"
            self.dateSortMode = .past
        case .past:
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.fetchAsset = PHAsset.fetchAssets(in: fetchCollection, options: fetchOptions)
            DispatchQueue.main.async {
                self.assetOfAlbumCollectionView.reloadData()
            }
            self.dateSortBarButton.title = "최신순"
            self.dateSortMode = .latest
        }
    }

    @objc func selectBarButtonClick(_ sender: UIBarButtonItem) {
        if selectMode == .view {
            selectBarButton.title = "선택"
            trashBarButton.isEnabled = false
            shareBarButton.isEnabled = false
            dateSortBarButton.isEnabled = true
            selectImage.removeAll()
            selectMode = .select
        } else {
            selectBarButton.title = "취소"
            trashBarButton.isEnabled = true
            shareBarButton.isEnabled = true
            dateSortBarButton.isEnabled = false
            selectMode = .view
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        setUpBarButtonItems()

        PHPhotoLibrary.shared().register(self)

        navigationItem.title = fetchCollection.localizedTitle
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewItemSize()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let asset = sender as! PHAsset

        if segue.identifier == viewImageSegueIdentifier {
            if let viewController = segue.destination as? ImageZoomViewController {
                viewController.asset = asset
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
        self.trashBarButton.isEnabled = false
        self.shareBarButton.isEnabled = false
    }
}

// MARK: - UICollectionViewDelegate
extension AssetOfAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch selectMode {
        case .view:
            guard let cell = assetOfAlbumCollectionView.cellForItem(at: indexPath) as? AssetOfAlbumCollectionViewCell else { return }
            if cell.imageView.alpha == 0.5 {
                cell.imageView.alpha = 1
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor.clear.cgColor

                self.selectImage.removeValue(forKey: indexPath.item)
                self.navigationItem.title = "\(self.selectImage.count)장 선택"

                if self.selectImage.count < 1 {
                    self.shareBarButton.isEnabled = false
                    self.trashBarButton.isEnabled = false
                    self.navigationItem.title = "항목 선택"
                }
            } else {
                cell.imageView.alpha = 0.5
                cell.imageView.layer.borderWidth = 1
                cell.imageView.layer.borderColor = UIColor.black.cgColor

                let asset = fetchAsset[indexPath.item]
                self.selectImage.updateValue(asset, forKey: indexPath.item)
                self.navigationItem.title = "\(self.selectImage.count)장 선택"

                self.shareBarButton.isEnabled = true
                self.trashBarButton.isEnabled = true
            }
        case .select:
            assetOfAlbumCollectionView.deselectItem(at: indexPath, animated: true)
            let asset = fetchAsset[indexPath.item]
            performSegue(withIdentifier: viewImageSegueIdentifier, sender: asset)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AssetOfAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchAsset.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = assetOfAlbumCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AssetOfAlbumCollectionViewCell else { return UICollectionViewCell() }

        DispatchQueue.global().async {
            let asset = self.fetchAsset[indexPath.item]
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil) { (image, _) in
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                    cell.imageView.alpha = 1
                    cell.imageView.layer.borderWidth = 0
                    cell.imageView.layer.borderColor = UIColor.clear.cgColor
                }
            }
        }

        return cell
    }
}

extension AssetOfAlbumViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchAsset) else { return }
        fetchAsset = changes.fetchResultAfterChanges
        DispatchQueue.main.async {
            self.assetOfAlbumCollectionView.reloadData()
        }
    }
}

extension AssetOfAlbumViewController {
    enum SelectMode {
        case view
        case select
    }

    enum DateSortMode {
        case latest
        case past
    }
}
