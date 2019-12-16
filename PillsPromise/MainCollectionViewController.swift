//
//  MainTableViewController.swift
//  PillsPromise
//
//  Created by guest on 2019/11/15.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit
import UserNotifications
class MainCollectionViewController: UICollectionViewController {
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var medicineList: MedicineList {
        return SingletoneMedicineList.shared.medicineList
    }
    
    /* required init?(coder: NSCoder) {
        medicineList = MedicineList()
        super.init(coder: coder)
    } */

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
//        mainCollectionView.allowsMultipleSelectionDuringEditing = true
//        mainCollectionView.allowsSelectionDuringEditing = true
        
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
        mainCollectionView.reloadData()
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
    
    func goItemDetail(_ sender: UICollectionViewCell) {
        if let itemDetailViewController = UIStoryboard(name: "ItemDetail", bundle: nil).instantiateViewController(identifier: "ItemDetailViewController") as? ItemDetailViewController
        {
            if let cell = sender as? UICollectionViewCell,
                let indexPath = mainCollectionView.indexPath(for: cell) {
                let item = medicineList.medicines[indexPath.row]
                itemDetailViewController.itemToEdit = item
                itemDetailViewController.delegate = self
            }
            navigationController?.pushViewController(itemDetailViewController, animated: true)
        }
    }
    
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = mainCollectionView.indexPathsForSelectedItems {
            var items = [MedicineItem]()
            for indexPath in selectedRows {
                items.append(medicineList.medicines[indexPath.row])
            }
            for item in items {
                item.deleteAlarmNotifications()
                item.deleteExpNotification()
            }
            medicineList.remove(items: items)
//            mainCollectionView.beginUpdates()
//            mainCollectionView.deleteRows(at: selectedRows, with:.automatic)
//            mainCollectionView.endUpdates()
            mainCollectionView.reloadData()
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
                if let cell = sender as? UICollectionViewCell,
                    let indexPath = mainCollectionView.indexPath(for: cell) {
                    let item = medicineList.medicines[indexPath.row]
                    itemDetailViewController.itemToEdit = item
                    itemDetailViewController.delegate = self
                }
            }
        }
    }

}

extension MainCollectionViewController {
    //UITableViewDelegate, UITableViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medicineList.medicines.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if !(super.isEditing) {
            goItemDetail(mainCollectionView.cellForItem(at: indexPath)!)
        }
        if !isEditing {
            deleteButton.isEnabled = false
        } else {
            deleteButton.isEnabled = true
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
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            deleteButton.isEnabled = false
        }
    }
    
    override func collectionView(_ tableView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /* cell을 tableView에 띄워 주는 함수 */
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MedicineItem", for: indexPath)
        
        let item = medicineList.medicines[indexPath.row]
        configureText(for: cell, with: item)
        
        return cell
    }
    
    // CollectionView에서 delete하는 reference로 변경
    
//    override func collectionView(_ collectionView: UICollectionView,
//                   commit editingStyle: UITableViewCell.EditingStyle,
//                   forRowAt indexPath: IndexPath){
//        /* swipe delete */
//        let item = medicineList.medicines[indexPath.row]
//        item.deleteAlarmNotifications()
//        item.deleteExpNotification()
//        medicineList.medicines.remove(at: indexPath.row)
//        let indexPaths = [indexPath]
//        collectionView.deleteRows(at: indexPaths, with: .automatic)
//        respondToPostNotification(self)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        /* moving */
        medicineList.move(item: medicineList.medicines[sourceIndexPath.row], to: destinationIndexPath.row)
        collectionView.reloadData()
        respondToPostNotification(self)
    }
    
    func configureText(for cell: UICollectionViewCell, with item: MedicineItem) {
        /* cell의 내용을 출력하는 함수 */
        if let medicineCell = cell as? MainCollectionViewCell {
            medicineCell.medicineTextLabel.text = item.name
            medicineCell.medicineExpirationLabel.text = item.date_expiration_string
            medicineCell.medicineInfoLabel.text = item.med_info
            medicineCell.medicineImageView.image = item.image
        }
    }
    
        // 사이즈
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
          let collectionViewCellWithd = collectionView.frame.width / 3 - 1
    
            return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd)
        }
    
    
        //위아래 라인 간격
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
            return 1
        }
    
        //옆 라인 간격
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
            return 1
        }

}

extension MainCollectionViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: MedicineItem){
        mainCollectionView.reloadData()
        respondToPostNotification(self)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: MedicineItem){
        mainCollectionView.reloadData()
        respondToPostNotification(self)
    }
}
