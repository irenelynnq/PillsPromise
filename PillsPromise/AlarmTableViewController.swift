import UIKit
import UserNotifications


class AlarmTableViewController: UITableViewController {
    
    var medicineList: MedicineList {
        return SingletoneMedicineList.shared.medicineList
    }
    
    var selectedItemForEdit: MedicineItem? = nil
    
    
    //알람 정보 있는 약들 불러오기

    var medicines_HavingAlarms: [MedicineItem]{
        let medicines = medicineList.listOfHavingAlarms()
        return medicines
    }
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        alarmTableView.allowsMultipleSelectionDuringEditing = true
        alarmTableView.allowsSelectionDuringEditing = true
        
          NotificationCenter.default.addObserver(self, selector: #selector(receiveModifiedNotification), name: Notification.Name("ModifiedNotification"), object: nil)
    }
    
    
       deinit {
           NotificationCenter.default.removeObserver(self, name: Notification.Name("ModifiedNotification"), object: nil)
       }
       
       func respondToPostNotification(_ sender: Any) {
           NotificationCenter.default.post(name: Notification.Name("ModifiedNotification"), object: nil)
       }
       
       @objc func receiveModifiedNotification(_ notification: Notification) {
           alarmTableView.reloadData()
           print("Alarm hear!")
       }
    
    
// alarm 디테일 뷰로 넘어가는 프리페어 셀
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AlarmDetailSegue" {
            if let itemDetailAlarmTableViewController = segue.destination as? ItemDetailAlarmTableViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = alarmTableView.indexPath(for: cell) {
                    let item = medicines_HavingAlarms[indexPath.row]
                    selectedItemForEdit = item
                itemDetailAlarmTableViewController.delegate = self
                itemDetailAlarmTableViewController.alarmList = item.alarms
                }
            }
        }
    }
    
    
    
    //delete
    
    @IBAction func deleteAlarms(_ sender: Any) {
        print("delete")
        
        if let selectedRows = alarmTableView.indexPathsForSelectedRows {
            var items = [MedicineItem]()
            for indexPath in selectedRows {
                items.append(medicineList.listOfHavingAlarms()[indexPath.row])
            }
            for item in items {
                item.deleteAlarmNotifications()
            }
            medicineList.removeAlarms(items: items)
            alarmTableView.beginUpdates()
            alarmTableView.deleteRows(at: selectedRows, with: .automatic)
            alarmTableView.endUpdates()
            respondToPostNotification(self)
        }
    }
    
    
    
    // swipe delete
    
    override func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath){
        let item = medicines_HavingAlarms[indexPath.row]
        item.deleteAlarmNotifications()
        medicineList.removeAlarms(items: [item])
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        respondToPostNotification(self)
    }
    
    // moving 됨
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        medicineList.move(item: medicines_HavingAlarms[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
    }


    
    // 디스플레이
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medicines_HavingAlarms.count
    }

    // cell 을 tableview에 띄어주고 출력하는 함수들
    
    func configureText(for cell: UITableViewCell, with item: MedicineItem) {
           
       if let medicineCell = cell as? AlarmTableViewCell {
        medicineCell.AlarmMedicineTextLabel.text = item.name
        medicineCell.alarmListLabel.text = item.alarms_string_concat
       }
           
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmMedicineItem", for: indexPath)
        cell.selectionStyle = .default
        let item = medicines_HavingAlarms[indexPath.row]
        configureText(for: cell, with: item)
        
        return cell
    }
    
    
    
}



extension AlarmTableViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: MedicineItem){
        alarmTableView.reloadData()
        respondToPostNotification(self)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: MedicineItem){
        alarmTableView.reloadData()
        respondToPostNotification(self)
    }
}
 

extension AlarmTableViewController: ItemDetailAlarmTableViewControllerDelegate {
    func itemDetailAlarmTableViewController(_ controller: ItemDetailAlarmTableViewController, didFinishEditing alarms: [Date]) {
        if let item = selectedItemForEdit {
            item.deleteAlarmNotifications()
            item.alarms = alarms
            item.setAlarmNotifications()
        }
        
        selectedItemForEdit = nil
        alarmTableView.reloadData()
        respondToPostNotification(self)
    }
    
    
}

