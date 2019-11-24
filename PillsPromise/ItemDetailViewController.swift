//
//  AddItemViewController.swift
//  PillsPromise
//
//  Created by guest on 2019/11/17.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: MedicineItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: MedicineItem)
}

class ItemDetailViewController: UITableViewController {
    weak var delegate: ItemDetailViewControllerDelegate?
    weak var medicineList: MedicineList?
    weak var itemToEdit: MedicineItem?
    
    @IBOutlet weak var itemDetailTableView: UITableView!
    
    @IBOutlet weak var textfield_name: UITextField!
    @IBOutlet weak var textfield_med_info: UITextField!
    @IBOutlet weak var textfield_take_info: UITextField!
    @IBOutlet weak var label_date_expiration: UILabel!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteExpirationDateButton: UIButton!
    
    var temp_date_expiration: Date?
    var temp_alarms: [Date] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textfield_name.text = item.name
            textfield_med_info.text = item.med_info
            textfield_take_info.text = item.take_info
            temp_date_expiration = item.date_expiration
            temp_alarms = item.alarms
            addBarButton.isEnabled = true
        }
        loadExpirationDate()

        navigationItem.largeTitleDisplayMode = .never
    }
    
    func loadExpirationDate(){
        if let date = temp_date_expiration {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .long
            dateformatter.timeStyle = .none
            label_date_expiration.text = dateformatter.string(from: date)
            label_date_expiration.isEnabled = true
            deleteExpirationDateButton.isEnabled = true
        } else {
            label_date_expiration.text = "설정 없음"
            label_date_expiration.isEnabled = false
            deleteExpirationDateButton.isEnabled = false
        }
    }
    
    @IBAction func deleteExpirationDate(){
        temp_date_expiration = nil
        loadExpirationDate()
    }
    
    func viewWillApper(_ animated: Bool) { //why not override?
        super.viewWillAppear(animated)
        //뷰가 나올 때 바로 이 필드를 편집할 수 있게 해줌
        textfield_name.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "EditDateExpirationSegue"{
            if let datePickerExpirationViewController = segue.destination as? DatePickerExpirationViewController {
                datePickerExpirationViewController.delegate = self
                datePickerExpirationViewController.dateToEdit = temp_date_expiration
            }
        } else if segue.identifier == "AlarmDetailSegue" {
            if let itemDetailAlarmTableViewController = segue.destination as? ItemDetailAlarmTableViewController {
                itemDetailAlarmTableViewController.delegate = self
                itemDetailAlarmTableViewController.alarmList = temp_alarms
            }
        }
    }
    
    
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        if let item = itemToEdit{
            if let text_name = textfield_name.text {
                item.name = text_name
            }
            if let text_med_info = textfield_med_info.text {
                item.med_info = text_med_info
            }
            if let text_take_info = textfield_take_info.text{
                item.take_info = text_take_info
            }
            item.date_expiration = temp_date_expiration
            item.alarms = temp_alarms
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            if let item = medicineList?.newMedicine() {
                if let text_name = textfield_name.text {
                    item.name = text_name
                }
                if let text_med_info = textfield_med_info.text {
                    item.med_info = text_med_info
                }
                if let text_take_info = textfield_take_info.text{
                    item.take_info = text_take_info
                }
                item.date_expiration = temp_date_expiration
                item.alarms = temp_alarms
                delegate?.itemDetailViewController(self, didFinishAdding: item)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        return nil
    }

}

extension ItemDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield_name.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField,
               shouldChangeCharactersIn range: NSRange,
               replacementString string: String) -> Bool {
        guard let oldText = textfield_name.text,
        let stringRange = Range(range, in: oldText) else {
            return false
        }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        //add 버튼 활성화
        addBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
}

extension ItemDetailViewController: DatePickerExpirationViewControllerDelegate {
    func datePickerExpirationViewController(_ controller: DatePickerExpirationViewController, didFinishEditing date: Date){
        temp_date_expiration = date
        loadExpirationDate()
        //itemDetailTableView.reloadData()
    }
}

extension ItemDetailViewController: ItemDetailAlarmTableViewControllerDelegate {
    func itemDetailAlarmTableViewController(_ controller: ItemDetailAlarmTableViewController, didFinishEditing alarms: [Date]){
        temp_alarms = alarms
    }
}
