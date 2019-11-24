//
//  DatePickerExpirationViewController.swift
//  PillsPromise
//
//  Created by guest on 2019/11/24.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

protocol DatePickerExpirationViewControllerDelegate: class {
    func datePickerExpirationViewController(_ controller: DatePickerExpirationViewController, didFinishEditing date: Date)
}

class DatePickerExpirationViewController: UIViewController {
    weak var delegate: DatePickerExpirationViewControllerDelegate?
    var dateToEdit: Date?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let date = dateToEdit {
            datePicker.date = date
        } else {
            datePicker.date = Date()
        }
    }
    @IBAction func done(_ sender: Any) {
        let dateEdited = datePicker.date
        delegate?.datePickerExpirationViewController(self, didFinishEditing: dateEdited)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
