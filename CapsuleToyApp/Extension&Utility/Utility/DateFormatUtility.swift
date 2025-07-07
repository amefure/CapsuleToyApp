//
//  DateFormatUtility.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/01/26.
//

import UIKit

class DateFormatUtility {
    
    public let df = DateFormatter()
    private let c = Calendar(identifier: .gregorian)

    init() {
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ja_JP")
        df.calendar = c
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
    }
}
    
// MARK: -　DateFormatter
extension DateFormatUtility {
    
    /// `Date`型を受け取り`String`型を返す
    public func getString(date: Date) -> String {
        return df.string(from: date)
    }
    
    /// `String`型を受け取り`Date`型を返す
    public func getDate(str: String) -> Date {
        return df.date(from: str) ?? Date()
    }
}

// MARK: - 　Calendar
extension DateFormatUtility {
    /// `Date`型を受け取り`DateComponents`型を返す
    /// - Parameters:
    ///   - date: 変換対象の`Date`型
    ///   - components: `DateComponents`で取得したい`Calendar.Component`
    /// - Returns: `DateComponents`
    public func convertDateComponents(date: Date, components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]) -> DateComponents {
        c.dateComponents(components, from: date)
    }
}
