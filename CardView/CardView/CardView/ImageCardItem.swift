//
//  ImageCardItem.swift
//  ImageCardItem
//
//  Created by chq on 2018/1/27.
//  Copyright © 2018年 chq. All rights reserved.
//

import UIKit

class ImageCardItem: CardItem {

    var image: UIImage
    var imageView: UIImageView!
    init(image: UIImage) {
        self.image = image
        super.init(frame: CGRect.zero)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        imageView = UIImageView()
        imageView.image = image
       contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        imageView.frame = bounds
    }
    
}
