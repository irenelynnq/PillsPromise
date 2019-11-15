//
//  MainTableViewController.swift
//  PillsPromise
//
//  Created by guest on 2019/11/15.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    @IBOutlet weak var mainTableView: UITableView!  
    
    var medicineList: MedicineList
    
    required init?(coder: NSCoder) {
        medicineList = MedicineList()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

}

extension MainTableViewController {
    //UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Incomplete implementation, return the number of rows
        return medicineList.medicines.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineItem", for: indexPath)
        
        
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = medicineList.medicines[indexPath.row].name
        }
        return cell
    }
}
