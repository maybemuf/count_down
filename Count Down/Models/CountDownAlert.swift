//
//  CountDownAlert.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 19.01.2024.
//

import Foundation
import RealmSwift

enum AlertOption: String, PersistableEnum, CaseIterable {
    case none = "None"
    case atFinish = "When finished"
    case fiveMinutesBefore = "5 minutes before"
    case thirtyMinutesBefore = "30 minutes before"
    case oneHourBefore = "1 hour before"
    
    func getDescriptionText(for countDown: String) -> String {
        switch self {
        case .none: return ""
        case .atFinish: return "\(countDown) have been completed"
        case .fiveMinutesBefore: return "Five minutes before \(countDown)"
        case .thirtyMinutesBefore: return "Thirty minutes before \(countDown)"
        case .oneHourBefore: return "One hour before \(countDown)"
        }
    }
    
    var minutesUntil: Int {
        switch self {
        case .none, .atFinish: return 0
        case .fiveMinutesBefore: return 5
        case .thirtyMinutesBefore: return 30
        case .oneHourBefore: return 60
        }
    }
}

class CountDownAlert: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var alertOption = AlertOption.none
    
    convenience init(_ alertOption: AlertOption) {
        self.init()
        self.alertOption = alertOption
    }
}
