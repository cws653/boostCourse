//
//  ImageZoomViewController.swift
//  MyAlbumV4
//
//  Created by 최원석 on 2020/08/22.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos

class ImageZoomViewController: UIViewController {

    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    @IBOutlet weak var trashBarButton: UIBarButtonItem!
    @IBOutlet weak var zoomImageView: UIImageView!

    var asset: PHAsset?
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var favoriteMode: FavoriteMode = .notFavorite {
        didSet {
            switch favoriteMode {
            case .favorite:
                favoriteBarButton.image = UIImage(systemName: "heart.fill")
            case .notFavorite:
                favoriteBarButton.image = UIImage(systemName: "heart")
            }
        }
    }

    @IBAction func favoriteBarButtonClick(_ sender: UIBarButtonItem) {
        favoriteMode = favoriteMode == .notFavorite ? .favorite : .notFavorite
    }

    @IBAction func shareBarButtonClick(_ sender: UIBarButtonItem) {
        let url: String = "www.naver.com"
        var shareObject: [Any] = []

        shareObject.append(url)

        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        //        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]

        self.present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func deleteBarButtonItem(_ sender: UIBarButtonItem) {
//        var deleteNeededIndexPaths: [IndexPath] = []
//        for (key, value) in dictionarySelectedIndexPath {
//            if value {
//                deleteNeededIndexPaths.append(key)
//            }
//        }
//
//        let assetArray: NSMutableArray = NSMutableArray()
//        for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
//            guard let asset = self.fetchResult?.object(at: i.item) else { return }
//            assetArray.addObjects(from: [asset])
//        }
//
//        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(assetArray)})
//        assetOfAlbumCollectionView.deleteItems(at: deleteNeededIndexPaths)
//        dictionarySelectedIndexPath.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    private func setUI() {
        guard let asset = self.asset else { return }
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in self.zoomImageView.image = image})

        let dateFomatter = DateFormatter()
        dateFomatter.locale =  Locale(identifier: "ko")
        dateFomatter.dateStyle = .full

        guard let creationDate = asset.creationDate else { return }
        navigationController?.title = dateFomatter.string(from: creationDate)
    }
}

extension ImageZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomImageView
    }
}

extension ImageZoomViewController {
    enum FavoriteMode {
        case favorite
        case notFavorite
    }
}
