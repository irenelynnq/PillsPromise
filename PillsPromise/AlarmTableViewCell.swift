//
//  AlarmTableViewCell.swift
//  PillsPromise
//
//  Created by 김민정 on 25/11/2019.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    var viewModel: MedicineItem? {
        didSet {
            if let viewModel = viewModel {
                AlarmMedicineTextLabel.text = "\(viewModel.name)"
            }
        }
    }
    
    @IBOutlet weak var AlarmMedicineTextLabel: UILabel!    
    @IBOutlet weak var alarmListLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
