//
//  MedicineItem.swift
//  PillsPromise
//
//  Created by guest on 2019/11/15.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class MedicineItem: NSObject, NSCoding {
    
    init(name: String, med_info: String, date_expiration: Date?, take_info: String, other_info: String, alarms: [Date], image: UIImage?) {
        self.name = name
        self.med_info = med_info
        self.date_expiration = date_expiration
        self.take_info = take_info
        self.other_info = other_info
        self.alarms = alarms
        self.image = image
    }
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.med_info, forKey: "med_info")
        coder.encode(self.date_expiration, forKey: "date_expiration")
        coder.encode(self.take_info, forKey: "take_info")
        coder.encode(self.other_info, forKey: "other_info")
        coder.encode(self.alarms, forKey: "alarms")
        coder.encode(self.image, forKey: "image")
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: "name") as? String else {return nil}
        let med_info = coder.decodeObject(forKey: "med_info") as? String ?? ""
        let date_expiration = coder.decodeObject(forKey: "date_expiration") as? Date ?? nil
        let take_info = coder.decodeObject(forKey: "take_info") as? String ?? ""
        let other_info = coder.decodeObject(forKey: "other_info") as? String ?? ""
        let alarms = coder.decodeObject(forKey: "alarms") as? [Date] ?? []
        let image = coder.decodeObject(forKey: "image") as? UIImage ?? nil
        
        self.init(name: name, med_info: med_info, date_expiration: date_expiration, take_info: take_info, other_info: other_info, alarms: alarms, image: image)
    }
    
    var name = ""
    var med_info = ""
    var date_expiration: Date? = nil //유통기한 탭에서는 이걸 기준으로 필터해서 보여줍니다
    var date_expiration_string: String {
        //유통기한을 -년-월-일의 스트링으로 만들어 줌
        get{
            if let date = date_expiration {
                //유통기한이 존재할 경우
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = .long
                dateformatter.timeStyle = .none
                return dateformatter.string(from: date)
            }
            else {
                return "설정 없음"
            }
        }
    }
    var take_info = ""
    var other_info = ""
    var alarms: [Date] = [] //알람 탭에서는 이걸 기준으로 필터해서 보여줍니다
    var alarms_string: [String] {
        //알람을 오전/오후 -시-분의 스트링으로 만들어 줌 (알람이 없다면 빈 배열)
        get {
            var strings: [String] = []
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .none
            dateformatter.timeStyle = .short
            for date in alarms {
                strings.append(dateformatter.string(from: date))
            }
            return strings
        }
    }
    var alarms_string_concat: String {
        var string = ""
        for time in alarms_string {
            string.append(time)
            string.append(", ")
        }
        string = String(string.dropLast(2))
        return string
    }
    
    var image: UIImage? = nil
    
    func deleteAlarmNotifications(){
        for index in 0...alarms.count {
            var id = self.name
            id.append("_alarm")
            id.append(String(index))
            center.removePendingNotificationRequests(withIdentifiers: [id])
            center.removeDeliveredNotifications(withIdentifiers: [id])
        }
    }
    
    func deleteExpNotifications(){
        var id = self.name
        id.append("_exp")
        center.removePendingNotificationRequests(withIdentifiers: [id])
        center.removeDeliveredNotifications(withIdentifiers: [id])
    }
    
    func setNotifications(){
        
    }
    
    func deleteAlarms(){
        alarms.removeAll()
    }
}





//얘는 사용
extension Date {
    func adding(day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: self)!
    }
}
