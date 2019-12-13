//
//  MedicineItem.swift
//  PillsPromise
//
//  Created by guest on 2019/11/15.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class MedicineItem: NSObject {
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
    
    var calendar = Calendar.current
    
    func deleteAlarms(){
        alarms.removeAll()
    }
}

//이거 필요없어요
/*
extension MedicineItem {
    var isExpirationOrLeftMonthItem: Bool {
                
        // 유통기한 오늘기준 지난거
        let expired = date_expiration! < Date()
        
        // 오늘기준 30일 남은 거
        let monthLater = Date().adding(day: 30)
        let leftOneMonth = date_expiration! < monthLater
        
        if expired || leftOneMonth {
            return true
            
        } else {
            return false
        }
    }
}
*/

//얘는 사용
extension Date {
    func adding(day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: self)!
    }
}
