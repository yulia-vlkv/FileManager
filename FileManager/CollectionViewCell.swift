//
//  ItemCell.swift
//  FileManager
//
//  Created by Iuliia Volkova on 13.05.2022.
//

import Foundation
import UIKit


class CollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "PictureCell"
    
    let pictureImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pictureImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupPicturesImageView()
    }
    
    private func setupPicturesImageView() {
        addSubview(pictureImageView)
        
        let constraints = [
            pictureImageView.topAnchor.constraint(equalTo: self.topAnchor),
            pictureImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pictureImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pictureImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
