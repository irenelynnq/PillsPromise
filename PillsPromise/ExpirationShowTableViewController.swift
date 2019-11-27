//
//  ExpirationShowTableViewController.swift
//  PillsPromise
//
//  Created by Jungmin Wang on 25/11/2019.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class ExpirationShowTableViewController: UITableViewController {

    // 데이터 가져왔어요
    var medicineList : MedicineList {
        return SingletoneMedicineList.shared.medicineList
    }
    
    //아래 medicines는 필요 없어요
    // Use for tableview
    var medicines: [MedicineItem] {
        // Computed Property
        // 한달 필터링
        let medicines = self.medicineList.medicines.filter { $0.isExpirationOrLeftMonthItem }
        return medicines
    }
    
    //아래의 두 배열들 사용해서 섹션 나눠서 프린트해주세요. 유통기한도 나와야 해요
    //유통기한 지난 것
    var medicines_expired: [MedicineItem] {
        let medicines = medicineList.medicines.filter {
            if let date_ex = $0.date_expiration{
                return (date_ex < Date())
            } else {
                return false
            }
        }
        return medicines
    }
    
    //한달 남은 것
    var medicines_month: [MedicineItem] {
        let medicines = medicineList.medicines.filter {
            if let date_ex = $0.date_expiration {
                if date_ex >= Date() && date_ex < Date().adding(day: 30){
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        return medicines
    }
 
    
    @IBOutlet weak var expirationShowTableView: UITableView! {
        didSet {
            // set up
            expirationShowTableView.delegate = self
            expirationShowTableView.dataSource = self
            expirationShowTableView.separatorStyle = .none
            expirationShowTableView.rowHeight = UITableView.automaticDimension
            expirationShowTableView.estimatedRowHeight = 128.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension ExpirationShowTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ExpirationShowTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MedicineItem", for: indexPath) as? ExpirationShowTableViewCell {
            cell.selectionStyle = .none
            cell.viewModel = medicines[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
}
