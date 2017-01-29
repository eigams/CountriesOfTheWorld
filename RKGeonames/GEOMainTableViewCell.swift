//
//  GEOMainTableViewCell.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/20/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation


class GEOMainTableViewCell: UITableViewCell {
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var capitalCityLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with country:GEOCountry, flag: UIImage) {
        countryNameLabel.text = country.countryName
        capitalCityLabel.text = country.capitalCity
        
        flagImage.image = flag
    }
}
