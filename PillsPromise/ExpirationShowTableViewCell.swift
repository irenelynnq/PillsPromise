//
//  ExpirationShowTableViewCell.swift
//  PillsPromise
//
//  Created by Jungmin Wang on 25/11/2019.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class ExpirationShowTableViewCell: UITableViewCell {

    var viewModel: MedicineItem? {
        didSet {
            if let viewModel = viewModel {
                expirationTextLabel.text = "\(viewModel.name)"

            }
        }
    }
    
    @IBOutlet weak var expirationTextLabel: UILabel!
    @IBOutlet weak var expirationDateTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

