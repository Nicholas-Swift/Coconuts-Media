//
//  CityTableViewCell.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 1/10/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    // UI Elements
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
    
}
