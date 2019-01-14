//
//  InsetsLabel.swift
//  NewsFeed
//
//  Created by Игорь Томилин on 1/14/19.
//  Copyright © 2019 igortomilin. All rights reserved.
//

import UIKit

class InsetsLabel: UILabel {

    var insets: UIEdgeInsets = .zero {
        didSet {
            if oldValue != insets {
                setNeedsDisplay()
                sizeToFit()
            }
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
}
