//
//  ExpirationShowTableViewController.swift
//  PillsPromise
//
//  Created by Jungmin Wang on 25/11/2019.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class ExpirationShowTableViewController: UITableViewController {

    var medicineList : MedicineList {
        return SingletoneMedicineList.shared.medicineList
    }

    //유통기한 지난 것
    var medicines_expired: [MedicineItem] {
        let medicines = medicineList.medicines.filter {
            if let date_ex = $0.date_expiration{
                return (date_ex < Date())
            } else {
                return false
            }
        }
        return medicines
    }
    
    //한달 남은 것
    var medicines_month: [MedicineItem] {
        let medicines = medicineList.medicines.filter {
            if let date_ex = $0.date_expiration {
                if date_ex >= Date() && date_ex < Date().adding(day: 30){
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        return medicines
    }
    
    let sections: [String] = ["유통기한 만료", "유통기한 임박"]
 
    
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
    
    // Returns the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // Returns the title of the section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    // Called when Cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            print("Value: \(medicines_expired[indexPath.row])")
            
        } else if indexPath.section == 1 {
            print("Value: \(medicines_month[indexPath.row])")

        } else {
            return
        }
        
    }
    
    // Returns the total number of arrays to display in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return medicines_expired.count
            
        } else if section == 1 {
            return medicines_month.count
            
        } else {
            return 0
            
        }
        
    }
    
    // Set a value in Cell
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineItem", for: indexPath)
        
        if indexPath.section == 0 {
            //cell.textLabel?.text = "\(medicines_expired[indexPath.row])"
            let item = medicines_expired[indexPath.row]
            configureText(for: cell, with: item)
            
        } else if indexPath.section == 1 {
            //cell.textLabel?.text = "\(medicines_month[indexPath.row])"
            let item = medicines_month[indexPath.row]
            configureText(for: cell, with: item)
            
        } else {
            return UITableViewCell()
            
        }
        
        return cell
        
    }

    
    func configureText(for cell: UITableViewCell, with item: MedicineItem) {
        
        if let medicineCell = cell as? ExpirationShowTableViewCell {
            medicineCell.expirationTextLabel.text = item.name
        }

        if let medicineCell = cell as? ExpirationShowTableViewCell {
            medicineCell.expirationDateTextLabel.text = item.date_expiration_string
        }

    }
    
}
