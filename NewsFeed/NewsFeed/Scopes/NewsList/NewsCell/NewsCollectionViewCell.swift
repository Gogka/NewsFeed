//
//  NewsCollectionViewCell.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/13/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var newsImageVIew: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var seenLabel: UILabel!
    
    var imageIdentifier: String?
    
    var isSeen = false {
        didSet {
            guard oldValue != isSeen else { return }
            seenLayer.isHidden = !isSeen
            seenLabel?.isHidden = !isSeen
        }
    }
    
    private let shadow: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private let seenLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsTitle?.textColor = .white
        newsTitle?.text = "Seen"
        newsImageVIew?.contentMode = .scaleAspectFill
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        layer.insertSublayer(shadow, below: contentView.layer)
        backgroundColor = .clear
        clipsToBounds = false
        contentView.layer.addSublayer(seenLayer)
        seenLayer.isHidden = true
        seenLabel?.isHidden = true
        seenLabel?.text = "Seen"
        seenLabel?.textColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        shadow.path = path
        shadow.shadowPath = path
        seenLayer.path = path
    }

}
