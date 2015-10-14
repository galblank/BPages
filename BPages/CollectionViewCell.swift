//
//  CollectionViewCell.swift
//  BPages
//
//  Created by Gal Blank on 10/13/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var textLabel: UILabel!
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        scrollView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(scrollView)
        
        textLabel = UILabel(frame: CGRect(x: 0, y:(frame.size.height - 50.0), width: frame.size.width, height:50.0))
        textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        textLabel.textColor = UIColor.whiteColor()
        textLabel.alpha = 0.8
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .Center
        textLabel.backgroundColor = UIColor.blackColor()
        textLabel.text = "hasjdfkads kfajskdfjkasdhf"
        contentView.addSubview(textLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
