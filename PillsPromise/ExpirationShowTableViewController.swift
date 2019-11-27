//
//  ExpirationShowTableViewController.swift
//  PillsPromise
//
//  Created by Jungmin Wang on 25/11/2019.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class ExpirationShowTableViewController: UITableViewController {

    // Fetched data list
    var medicineList : MedicineList = MedicineList()
        
    // Use for tableview
    var medicines: [MedicineItem] {
        // Computed Property
        // 한달 필터링
        let medicines = self.medicineList.medicines.filter { $0.isExpirationOrLeftMonthItem }
        return medicines
    }

    @IBOutlet weak var expirationShowTableView: UITableView! {
        didSet {
            // set up
            expirationShowTableView.delegate = self
            expirationShowTableView.dataSource = self
            expirationShowTableView.separatorStyle = .none
            expirationShowTableView.rowHeight = UITableView.automaticDimension
            expirationShowTableView.estimatedRowHeight = 128.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension ExpirationShowTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ExpirationShowTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MedicineItem", for: indexPath) as? ExpirationShowTableViewCell {
            cell.selectionStyle = .none
            cell.viewModel = medicines[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
}
