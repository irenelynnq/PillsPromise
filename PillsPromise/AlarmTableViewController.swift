//
//  AlarmTableViewController.swift
//  PillsPromise
//
//  Created by 김민정 on 25/11/2019.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {
    
    var medicineList: MedicineList {
        return SingletoneMedicineList.shared.medicineList
    }
    
//알람 정보 있는 것

    var medicines_HavingAlarms: [MedicineItem]{
        let medicines = medicineList.listOfHavingAlarms()
        return medicines
    }
    
    @IBOutlet weak var AlarmTableView: UITableView! {
        didSet {
            // set up 테이블 뷰 꾸민 것?
            AlarmTableView.delegate = self
            AlarmTableView.dataSource = self
            AlarmTableView.separatorStyle = .none
            AlarmTableView.rowHeight = UITableView.automaticDimension
            AlarmTableView.estimatedRowHeight = 128.0
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    //delete
    
    @IBAction func deleteAlarms(_ sender: Any) {
        if let selectedRows = AlarmTableView.indexPathsForSelectedRows {
            var items = [MedicineItem]()
            for indexPath in selectedRows {
                items.append(medicineList.listOfHavingAlarms()[indexPath.row])
            }
            for item in items {
                item.deleteAlarms()
            }
            AlarmTableView.beginUpdates()
            AlarmTableView.deleteRows(at: selectedRows, with: .automatic)
            AlarmTableView.endUpdates()
        }
    }
    
  /*
     @IBAction func deleteItems(_ sender: Any) {
         if let selectedRows = mainTableView.indexPathsForSelectedRows {
             var items = [MedicineItem]()
             for indexPath in selectedRows {
                 items.append(medicineList.medicines[indexPath.row])
             }
             medicineList.remove(items: items)
             mainTableView.beginUpdates()
             mainTableView.deleteRows(at: selectedRows, with: .automatic)
             mainTableView.endUpdates()
         }
     }

            override func tableView(_ tableView: UITableView,
                           commit editingStyle: UITableViewCell.EditingStyle,
                           forRowAt indexPath: IndexPath){
                MedicineItem.deleteAlarms(self)(at: indexPath.row)
                let indexPaths = [indexPath]
                tableView.deleteRows(at: indexPaths, with: .automatic)
            }
   */
    //item 추가 & 편집
/*
    override func setEditing(_ editing: Bool, animated: Bool) {
         AlarmTableView.setEditing(!AlarmTableView.isEditing, animated: true)
         super.setEditing(editing, animated: true)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?){
         if segue.identifier == "AddItemSegue"{
             if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                 itemDetailViewController.delegate = self
                 itemDetailViewController.medicineList = medicineList
             }
         } else if segue.identifier == "EditItemSegue" {
             if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                 if let cell = sender as? UITableViewCell,
                     let indexPath = AlarmTableView.indexPath(for: cell) {
                     let item = medicineList.medicines[indexPath.row]
                     itemDetailViewController.itemToEdit = item
                     itemDetailViewController.delegate = self
                 }
             }
         }
     }
*/

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medicines_HavingAlarms.count
    }

    // cell 을 tableview에 띄어주고 출력하는 함수들
    
    func configureText(for cell: UITableViewCell, with item: MedicineItem) {
           
           if let medicineCell = cell as? AlarmTableViewCell {
               medicineCell.AlarmMedicineTextLabel.text = item.name
           }
           
           }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineItem", for: indexPath)
        
        let item = medicines_HavingAlarms[indexPath.row]
        configureText(for: cell, with: item)
        
        return cell
    }
    



    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
