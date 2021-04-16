//
//  ImageZoomViewController.swift
//  MyAlbumV4
//
//  Created by 최원석 on 2020/08/22.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos

class ImageZoomViewController: UIViewController, UIScrollViewDelegate {

    var asset: PHAsset!
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    @IBOutlet weak var zoomImageView: UIImageView!

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in self.zoomImageView.image = image})
    }
}
