//
//  DatePickerAlarmViewController.swift
//  PillsPromise
//
//  Created by guest on 2019/11/25.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

protocol DatePickerAlarmViewControllerDelegate: class {
    func datePickerAlarmViewController(_ controller: DatePickerAlarmViewController, didFinishAdding alarm: Date)
    func datePickerAlarmViewController(_ controller: DatePickerAlarmViewController, didFinishEditing alarm: Date)
}

class DatePickerAlarmViewController: UIViewController {
    weak var delegate: DatePickerAlarmViewControllerDelegate?
    var alarmList: [Date]?
    var alarmToEdit: Date?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let alarm = alarmToEdit {
            datePicker.date = alarm
        } else {
            datePicker.date = Date()
        }
    }
    @IBAction func done(_ sender: Any) {
        if let alarm = alarmToEdit {
            alarmToEdit! = datePicker.date
            delegate?.datePickerAlarmViewController(self, didFinishEditing: alarmToEdit!)
        } else {
            let alarm = datePicker.date
            alarmList!.append(alarm)
            delegate?.datePickerAlarmViewController(self, didFinishAdding: alarm)
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
