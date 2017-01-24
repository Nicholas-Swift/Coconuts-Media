//
//  NavigationLogoView.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 12/11/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class NavigationLogoView: UIView {
    
    var imageView: UIImageView = UIImageView()
    
    init(city: String) {
        
        // Create label to get width
        let label: UILabel = UILabel()
        label.text = city
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        // Create frame based on label
        let width = label.intrinsicContentSize.width
        let frame = CGRect(x: 24, y: 0, width: width, height: 24)
        
        // Set extra label stuff
        label.frame = frame
        label.textAlignment = .center
        
        // Create down arrow
        let imageFrame = CGRect(x: width + 8 + 24, y: 0, width: 16, height: 24)
        imageView.frame = imageFrame
        imageView.contentMode = .scaleAspectFit
        
        // Super init
        let mainFrame = CGRect(x: 0, y: 0, width: width + 24 + 24, height: 24)
        super.init(frame: mainFrame)
        
        // Add label and image
        self.addSubview(label)
        updateImage(up: false)
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImage(up: Bool) {
        imageView.image = up ? UIImage(named: "Collapse Arrow") : UIImage(named: "Expand Arrow")
    }
    
}
