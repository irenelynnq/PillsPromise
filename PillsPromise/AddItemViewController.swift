//
//  AddItemViewController.swift
//  PillsPromise
//
//  Created by guest on 2019/11/17.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: MedicineItem)
}

class AddItemViewController: UITableViewController {
    weak var delegate: AddItemViewControllerDelegate?
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var addBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
    }
    
    func viewWillApper(_ animated: Bool) { //why not override?
        super.viewWillAppear(animated)
        textfield.becomeFirstResponder()
    }
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        let item = MedicineItem()
        if let textFieldText = textfield.text {
            item.name = textFieldText
        }
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        return nil
    }

}

extension AddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField,
               shouldChangeCharactersIn range: NSRange,
               replacementString string: String) -> Bool {
    guard let oldText = textfield.text,
        let stringRange = Range(range, in: oldText) else {
            return false
        }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        addBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
}
