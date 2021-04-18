//
//  AssetOfAlbumCollectionViewCell.swift
//  MyAlbumV4
//
//  Created by 최원석 on 2021/04/17.
//  Copyright © 2021 최원석. All rights reserved.
//

import UIKit

class AssetOfAlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var highlightIndicator: UIView!

    override var isHighlighted: Bool{
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }

    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
        }
    }
}
