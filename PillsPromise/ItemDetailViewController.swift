//
//  AddItemViewController.swift
//  PillsPromise
//
//  Created by guest on 2019/11/17.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit
import UserNotifications
let center = UNUserNotificationCenter.current()

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
    @IBOutlet weak var textfield_other_info: UITextField!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteExpirationDateButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    
    @IBAction func imageAdd(_ sender: Any) {
        let alert = UIAlertController(title: "사진 편집", message: "약 사진을 편집합니다", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
            
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera()
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    var temp_date_expiration: Date?
    var temp_alarms: [Date] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        if let item = itemToEdit {
            title = "Edit Item"
            textfield_name.text = item.name
            textfield_med_info.text = item.med_info
            textfield_take_info.text = item.take_info
            temp_date_expiration = item.date_expiration
            textfield_other_info.text = item.other_info
            temp_alarms = item.alarms
            addBarButton.isEnabled = true
            imageView.image = item.image
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
            if let text_take_info = textfield_take_info.text {
                item.take_info = text_take_info
            }
            if let text_other_info = textfield_other_info.text {
                item.other_info = text_other_info
            }
            item.date_expiration = temp_date_expiration
            item.alarms = temp_alarms
            item.image = imageView.image
            delegate?.itemDetailViewController(self, didFinishEditing: item)
            var id = item.name
            id.append("_alarm")
            center.removePendingNotificationRequests(withIdentifiers: [id])
            center.removeDeliveredNotifications(withIdentifiers: [id])
            id = item.name
            id.append("_exp")
            center.removePendingNotificationRequests(withIdentifiers: [id])
            center.removeDeliveredNotifications(withIdentifiers: [id])
            
            for alarm in item.alarms {
                let content = UNMutableNotificationContent()
                content.title = "약 먹을 시간이에요"
                content.subtitle = item.name
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = .none
                dateformatter.timeStyle = .short
                content.body = dateformatter.string(from: alarm)
                let triggerDaily = Calendar.current.dateComponents([.hour, .minute], from: alarm)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                var identifier = item.name
                identifier.append("_alarm")
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request, withCompletionHandler: {(error) in if let error = error {
                    print(error)
                    }})
                if let date_exp = item.date_expiration {
                    let content = UNMutableNotificationContent()
                    content.title = "약의 유통기한이 다 되었어요"
                    content.subtitle = item.name
                    let dateformatter = DateFormatter()
                    dateformatter.dateStyle = .long
                    dateformatter.timeStyle = .none
                    content.body = dateformatter.string(from: date_exp)
                    let triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: date_exp)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    let identifier = item.name
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: {(error) in if let error = error {
                        print(error)
                        }})
                }
            }
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
                if let text_other_info = textfield_other_info.text {
                    item.other_info = text_other_info
                }
                item.date_expiration = temp_date_expiration
                item.alarms = temp_alarms
                item.image = imageView.image
                delegate?.itemDetailViewController(self, didFinishAdding: item)
                for alarm in item.alarms {
                    let content = UNMutableNotificationContent()
                    content.title = "약 먹을 시간이에요"
                    content.subtitle = item.name
                    let dateformatter = DateFormatter()
                    dateformatter.dateStyle = .none
                    dateformatter.timeStyle = .short
                    content.body = dateformatter.string(from: alarm)
                    let triggerDaily = Calendar.current.dateComponents([.hour, .minute], from: alarm)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                    var identifier = item.name
                    identifier.append("_alarm")
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: {(error) in if let error = error {
                        print(error)
                        }})
                }
                if let date_exp = item.date_expiration {
                    let content = UNMutableNotificationContent()
                    content.title = "약의 유통기한이 다 되었어요"
                    content.subtitle = item.name
                    let dateformatter = DateFormatter()
                    dateformatter.dateStyle = .long
                    dateformatter.timeStyle = .none
                    content.body = dateformatter.string(from: date_exp)
                    let triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: date_exp)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    var identifier = item.name
                    identifier.append("_exp")
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: {(error) in if let error = error {
                        print(error)
                        }})
                }
                
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        return nil
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
        else {
            print("Camera not available")
        }
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

extension ItemDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
            
            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
    
}


