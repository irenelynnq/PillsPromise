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
    
    @IBOutlet weak var textfield_name: UITextField!
    @IBOutlet weak var textfield_med_info: UITextField!
    @IBOutlet weak var textfield_take_info: UITextField!
    @IBOutlet weak var date_expiration: UILabel!
    @IBOutlet weak var addBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textfield_name.text = item.name
            textfield_med_info.text = item.med_info
            textfield_take_info.text = item.take_info
            //date_expiration.text = item.date_expiration ?? Date(timeIntervalSinceNow: 900000000000)
            addBarButton.isEnabled = true
        }

        navigationItem.largeTitleDisplayMode = .never
    }
    
    func viewWillApper(_ animated: Bool) { //why not override?
        super.viewWillAppear(animated)
        //뷰가 나올 때 바로 이 필드를 편집할 수 있게 해줌
        textfield_name.becomeFirstResponder()
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
