//
//  MainTableViewCell.swift
//  PillsPromise
//
//  Created by guest on 2019/11/18.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var medicineTextLabel: UILabel!
    @IBOutlet weak var medicineExpirationLabel: UILabel!
    @IBOutlet weak var medicineInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                // animate selection
            } else {
                // animate deselection
            }
        }
    }

}
