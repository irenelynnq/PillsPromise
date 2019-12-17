//
//  MainTableViewController.swift
//  PillsPromise
//
//  Created by guest on 2019/11/15.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit
import UserNotifications

class MainTableViewController: UITableViewController {
    @IBOutlet weak var mainTableView: UITableView!
    
    
    var medicineList: MedicineList {
        return SingletoneMedicineList.shared.medicineList
    }
    
    /*
    required init?(coder: NSCoder) {
        medicineList = MedicineList()
        super.init(coder: coder)
    }
 */

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.selectedImage = tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        mainTableView.allowsMultipleSelectionDuringEditing = true
        mainTableView.allowsSelectionDuringEditing = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveModifiedNotification), name: Notification.Name("ModifiedNotification"), object: nil)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) {(didAllow, Error )in }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ModifiedNotification"), object: nil)
    }
    
    func respondToPostNotification(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("ModifiedNotification"), object: nil)
    }
    
    @objc func receiveModifiedNotification(_ notification: Notification) {
        mainTableView.reloadData()
        SingletoneMedicineList.shared.medicineList.save()
        print("main hear!")
    }
    
    /*
    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = medicineList.medicines.count
        _ = medicineList.newMedicine()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
 */
    
    func goItemDetail(_ sender: UITableViewCell) {
        if let itemDetailViewController = UIStoryboard(name: "ItemDetail", bundle: nil).instantiateViewController(identifier: "ItemDetailViewController") as? ItemDetailViewController
        {
            if let cell = sender as? UITableViewCell,
                let indexPath = mainTableView.indexPath(for: cell) {
                let item = medicineList.medicines[indexPath.row]
                itemDetailViewController.itemToEdit = item
                itemDetailViewController.delegate = self
            }
            navigationController?.pushViewController(itemDetailViewController, animated: true)
        }
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = mainTableView.indexPathsForSelectedRows {
            var items = [MedicineItem]()
            for indexPath in selectedRows {
                items.append(medicineList.medicines[indexPath.row])
            }
            for item in items {
                item.deleteAlarmNotifications()
                item.deleteExpNotification()
            }
            medicineList.remove(items: items)
            mainTableView.beginUpdates()
            mainTableView.deleteRows(at: selectedRows, with: .automatic)
            mainTableView.endUpdates()
            respondToPostNotification(self)
            
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
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
                    let indexPath = mainTableView.indexPath(for: cell) {
                    let item = medicineList.medicines[indexPath.row]
                    itemDetailViewController.itemToEdit = item
                    itemDetailViewController.delegate = self
                }
            }
        }
    }

}

extension MainTableViewController {
    //UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineList.medicines.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if !(super.isEditing) {
            goItemDetail(mainTableView.cellForRow(at: indexPath)!)
        }
        /*
        else if super.isEditing {
            if let cell = mainTableView.cellForRow(at: indexPath) {
                cell.setSelected(true, animated: true)
                cell.setHighlighted(true, animated: true)
            }
        }
 */
            /*
        else {
            mainTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
 */
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
        let item = medicineList.medicines[indexPath.row]
        item.deleteAlarmNotifications()
        item.deleteExpNotification()
        medicineList.medicines.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        respondToPostNotification(self)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        /* moving */
        medicineList.move(item: medicineList.medicines[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
        respondToPostNotification(self)
    }
    
    func configureText(for cell: UITableViewCell, with item: MedicineItem) {
        /* cell의 내용을 출력하는 함수 */
        if let medicineCell = cell as? MainTableViewCell {
            medicineCell.medicineTextLabel.text = item.name
            medicineCell.medicineExpirationLabel.text = item.date_expiration_string
            medicineCell.medicineInfoLabel.text = item.med_info
            medicineCell.medicineImageView.image = item.image
        }
    }
    

}

extension MainTableViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: MedicineItem){
        mainTableView.reloadData()
        respondToPostNotification(self)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: MedicineItem){
        mainTableView.reloadData()
        respondToPostNotification(self)
    }
}
