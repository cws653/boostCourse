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

    var asset: PHAsset = PHAsset()
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var favoriteMode: FavoriteMode = .favorite

    @IBAction func favoriteBarButtonClick(_ sender: UIBarButtonItem) {
        switch favoriteMode {
        case .favorite:
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest(for: self.asset).isFavorite = false
            } completionHandler: { (success, error) in
                DispatchQueue.main.async {
                    self.favoriteBarButton.image = UIImage(systemName: "heart")
                    self.favoriteMode = .notFavorite
                }
            }
        case .notFavorite:
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest(for: self.asset).isFavorite = true
            } completionHandler: { (success, error) in
                DispatchQueue.main.async {
                    self.favoriteBarButton.image = UIImage(systemName: "heart.fill")
                    self.favoriteMode = .favorite
                }
            }
        }
    }

    @IBAction func shareBarButtonClick(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            var imageShare = UIImage()
            self.imageManager.requestImage(for: self.asset, targetSize: CGSize(width: self.asset.pixelWidth, height: self.asset.pixelHeight), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        imageShare = image

                        let activityViewController = UIActivityViewController(activityItems: [imageShare], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                }
            })
        }
    }

    @IBAction func deleteBarButtonItem(_ sender: UIBarButtonItem) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets([self.asset] as NSArray)
        } completionHandler: { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("\(String(describing: error))")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()

//        PHPhotoLibrary.shared().register(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        PHPhotoLibrary.shared().performChanges {
            if self.asset.isFavorite {
                DispatchQueue.main.async {
                    self.favoriteBarButton.image = UIImage(systemName: "heart.fill")
                }
                self.favoriteMode = .favorite
            } else {
                DispatchQueue.main.async {
                    self.favoriteBarButton.image = UIImage(systemName: "heart")
                }
                self.favoriteMode = .notFavorite
            }
        }
    }

    private func setUI() {

        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd"
        let timeFomatter = DateFormatter()
        timeFomatter.dateFormat = "a HH:mm:ss"
        guard let creationDate = self.asset.creationDate else { return }
        let date = dateFomatter.string(from: creationDate)
        let time = dateFomatter.string(from: creationDate)

        self.navigationItem.titleView = setTitle(title: date, subtitle: time)

        DispatchQueue.global().async {
            self.imageManager.requestImage(for: self.asset, targetSize: CGSize(width: self.asset.pixelWidth, height: self.asset.pixelHeight), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                DispatchQueue.main.async {
                    self.zoomImageView.image = image
                }
            })
        }
    }

    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 15, width: 0, height: 0))
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.size.width, height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width

        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }

        return titleView
    }
}

extension ImageZoomViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let change = changeInstance.changeDetails(for: self.asset) else { return }
        guard let asset = change.objectAfterChanges else { return }
        if asset.isFavorite != self.favoriteMode.bool {
            if asset.isFavorite {
                PHPhotoLibrary.shared().performChanges {
                    self.favoriteMode = .favorite
                } completionHandler: { (success, error) in
                    DispatchQueue.main.async {
                        self.favoriteBarButton.image = UIImage(systemName: "heart.fill")
                    }
                }
            } else {
                PHPhotoLibrary.shared().performChanges {
                    self.favoriteMode = .notFavorite
                } completionHandler: { (success, error) in
                    DispatchQueue.main.async {
                        self.favoriteBarButton.image = UIImage(systemName: "heart")
                    }
                }
            }
        }
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

        var bool: Bool {
            switch self {
            case .favorite:
                return true
            case .notFavorite:
                return false
            }
        }
    }
}
