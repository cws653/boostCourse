//
//  SecondCollectionViewCell.swift
//  MyAlbumV3
//
//  Created by 최원석 on 2020/08/20.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Photos

class SecondCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageManager: PHImageManager?
    var targetSizeX: CGFloat?
    
    var imageAsset: PHAsset? {
        didSet {
            // 여기서 CGSize를 정하는 것과 BurstAlbum의 CollectionView에서 CGSize를 정하는 것의 차이는 무엇일까?
            // imgView의 크기가 유동적으로 변할텐데 이상하게 최초의 값만 가지고 있어서 써먹을 수가 없다.
            print("imgView.frame.width = \(imageView.frame.width)")
            
            self.imageManager?.requestImage(for: imageAsset!, targetSize: CGSize(width: targetSizeX!, height: targetSizeX!), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in self.imageView.image = image})
        }
    }
}
