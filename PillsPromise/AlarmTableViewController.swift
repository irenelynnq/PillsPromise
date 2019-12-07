import UIKit

class AlarmTableViewController: UITableViewController {
    
    var medicineList: MedicineList {
        return SingletoneMedicineList.shared.medicineList
    }
    
    
    //알람 정보 있는 약들 불러오기

    var medicines_HavingAlarms: [MedicineItem]{
        let medicines = medicineList.listOfHavingAlarms()
        return medicines
    }
    
    @IBOutlet weak var AlarmTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        AlarmTableView.allowsMultipleSelectionDuringEditing = true
        
          NotificationCenter.default.addObserver(self, selector: #selector(receiveModifiedNotification), name: Notification.Name("ModifiedNotification"), object: nil)
    }
    
    
       deinit {
           NotificationCenter.default.removeObserver(self, name: Notification.Name("ModifiedNotification"), object: nil)
       }
       
       func respondToPostNotification(_ sender: Any) {
           NotificationCenter.default.post(name: Notification.Name("ModifiedNotification"), object: nil)
       }
       
       @objc func receiveModifiedNotification(_ notification: Notification) {
           AlarmTableView.reloadData()
           print("Alarm hear!")
       }
    
    
// alarm 디테일 뷰로 넘어가는 프리페어 셀
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AlarmDetailSegue" {
            if let itemDetailAlarmTableViewController = segue.destination as? ItemDetailAlarmTableViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = AlarmTableView.indexPath(for: cell) {
                    let item = medicines_HavingAlarms[indexPath.row]
                itemDetailAlarmTableViewController.delegate = self
                itemDetailAlarmTableViewController.alarmList = item.alarms
                }
            }
        }
    }
    
    
    //delete -> 안됨
    
    @IBAction func deleteAlarms(_ sender: Any) {
        if let selectedRows = AlarmTableView.indexPathsForSelectedRows {
            var items = [MedicineItem]()
            for indexPath in selectedRows {
                items.append(medicineList.listOfHavingAlarms()[indexPath.row])
            }
            medicineList.removeAlarms(items: items)
            AlarmTableView.beginUpdates()
            AlarmTableView.deleteRows(at: selectedRows, with: .automatic)
            AlarmTableView.endUpdates()
            respondToPostNotification(self)
        }
    }
    
    
    
    // swipe delete -> 되긴 하는데 알람 삭제는 안됨 셀만 사라짐
    
    override func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath){
        let item = medicines_HavingAlarms[indexPath.row]
        
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
       }
           
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmMedicineItem", for: indexPath)
        
        let item = medicines_HavingAlarms[indexPath.row]
        configureText(for: cell, with: item)
        
        return cell
    }
    
    }


extension AlarmTableViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: MedicineItem){
        AlarmTableView.reloadData()
        respondToPostNotification(self)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: MedicineItem){
        AlarmTableView.reloadData()
        respondToPostNotification(self)
    }
}

extension AlarmTableViewController: ItemDetailAlarmTableViewControllerDelegate {
    func itemDetailAlarmTableViewController(_ controller: ItemDetailAlarmTableViewController, didFinishEditing alarms: [Date]) {
        AlarmTableView.reloadData()
        respondToPostNotification(self)
    }
    
    
}

