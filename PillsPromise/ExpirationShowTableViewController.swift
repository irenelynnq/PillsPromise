//
//  ExpirationShowTableViewController.swift
//  PillsPromise
//
//  Created by Jungmin Wang on 25/11/2019.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class ExpirationShowTableViewController: UITableViewController {
    
    @IBOutlet weak var expirationShowTableView: UITableView!
    
    var medicineList: MedicineList
    
    required init?(coder: NSCoder) {
        medicineList = MedicineList()
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ExpirationShowTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medicineList.medicines.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
         let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "MedicineItem")
         cell.textLabel?.text = medicineList[indexPath.row]
        */
        
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineItem", for: indexPath)
        
        let item = medicineList.medicines[indexPath.row]
        configureText(for: cell, with: item)
        */
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineItem", for: indexPath)
        
        /*
        
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let today = format.string(from: )(Date())
        let dateformatter = DateFormatter()
        
        if medicineList.medicines[indexPath.row].date_expiration_string != "설정 없음" {

            let startDate = dateformatter.date(from:medicineList.medicines[indexPath.row].date_expiration_string)!
            let endDate = dateformatter.date(from:today)!

            let interval = endDate.timeIntervalSince(startDate)
            let days = Int(interval / 86400)
            
            if let label = cell.viewWithTag(1000) as? UILabel {
            
                if days <= 30 {
                    label.text = medicineList.medicines[indexPath.row].name
                    */
                    let item = medicineList.medicines[indexPath.row]
                    configureText(for: cell, with: item)
                    
                    return cell
                }
                
            }
           /*
        }
        
        
        return cell
        
    }
 */
    
    func configureText(for cell: UITableViewCell, with item: MedicineItem) {
        /* cell의 text를 출력하는 함수 */
        if let medicineCell = cell as? ExpirationShowTableViewCell {
            medicineCell.expirationTextLabel.text = item.name
        }
        
        
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

