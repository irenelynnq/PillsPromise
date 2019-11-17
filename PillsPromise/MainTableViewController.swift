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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = medicineList.medicines.count
        _ = medicineList.newMedicine()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AddItemSegue"{
            if let addItemViewController = segue.destination as? AddItemViewController {
                addItemViewController.delegate = self
            }
        }
    }

}

extension MainTableViewController {
    //UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineList.medicines.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* cell을 tableView에 띄워 주는 함수 */
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineItem", for: indexPath)
        
        let item = medicineList.medicines[indexPath.row]
        configureText(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath){
        /* swipe delete */
        medicineList.medicines.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureText(for cell: UITableViewCell, with item: MedicineItem) {
        /* cell의 text를 출력하는 함수 */
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = item.name
        }
    }
}

extension MainTableViewController: AddItemViewControllerDelegate {
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: MedicineItem){
        medicineList.medicines.append(item)
        
        mainTableView.reloadData()
    }
}
