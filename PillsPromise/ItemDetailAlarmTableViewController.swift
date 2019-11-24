//
//  AlarmTableTableViewController.swift
//  PillsPromise
//
//  Created by guest on 2019/11/25.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

protocol ItemDetailAlarmTableViewControllerDelegate: class {
    func itemDetailAlarmTableViewController(_ controller: ItemDetailAlarmTableViewController, didFinishEditing alarms: [Date])
}

class ItemDetailAlarmTableViewController: UITableViewController {
    weak var delegate: ItemDetailAlarmTableViewControllerDelegate?
    @IBOutlet weak var itemDetailAlarmTableView: UITableView!
    
    var alarmList: [Date] = []
    var alarmList_string: [String] {
        //알람을 오전/오후 -시-분의 스트링으로 만들어 줌 (알람이 없다면 빈 배열)
        get {
            var strings: [String] = []
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .none
            dateformatter.timeStyle = .short
            for date in alarmList {
                strings.append(dateformatter.string(from: date))
            }
            return strings
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        itemDetailAlarmTableView.allowsMultipleSelectionDuringEditing = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func deleteAlarms(_ sender: Any) {
        if let selectedRows = itemDetailAlarmTableView.indexPathsForSelectedRows {
            var dates = [Date]()
            for indexPath in selectedRows {
                dates.append(alarmList[indexPath.row])
            }
            for date in dates {
                if let index = alarmList.firstIndex(of: date) {
                    alarmList.remove(at: index)
                }
            }
            itemDetailAlarmTableView.beginUpdates()
            itemDetailAlarmTableView.deleteRows(at: selectedRows, with: .automatic)
            itemDetailAlarmTableView.endUpdates()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        itemDetailAlarmTableView.setEditing(!itemDetailAlarmTableView.isEditing, animated: true)
        super.setEditing(editing, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AddAlarmSegue"{
            if let datePickerAlarmViewController = segue.destination as? DatePickerAlarmViewController {
                datePickerAlarmViewController.delegate = self
                datePickerAlarmViewController.alarmList = alarmList
            }
        } else if segue.identifier == "EditAlarmSegue" {
            if let datePickerAlarmViewController = segue.destination as? DatePickerAlarmViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = itemDetailAlarmTableView.indexPath(for: cell) {
                    let alarm = alarmList[indexPath.row]
                    datePickerAlarmViewController.alarmToEdit = alarm
                    datePickerAlarmViewController.delegate = self
                }
            }
        }
    }

}

extension ItemDetailAlarmTableViewController {
    //UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* cell을 tableView에 띄워 주는 함수 */
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailAlarm", for: indexPath)
        let date_string = alarmList_string[indexPath.row]
        configureText(for: cell, with: date_string)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath){
        /* swipe delete */
        alarmList.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureText(for cell: UITableViewCell, with date_string: String) {
        /* cell의 text를 출력하는 함수 */
        if let alarmCell = cell as? ItemDetailAlarmTableViewCell {
            alarmCell.alarmTextLabel.text = date_string
        }
    }
}

extension ItemDetailAlarmTableViewController: DatePickerAlarmViewControllerDelegate {
    func datePickerAlarmViewController(_ controller: DatePickerAlarmViewController, didFinishAdding alarm: Date) {
        itemDetailAlarmTableView.reloadData()
    }
    
    func datePickerAlarmViewController(_ controller: DatePickerAlarmViewController, didFinishEditing alarm: Date) {
        itemDetailAlarmTableView.reloadData()
    }
}
