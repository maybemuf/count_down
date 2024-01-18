//
//  CountDown.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 24.12.2023.
//

import Foundation
import RealmSwift

class CountDown: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var name: String
    @Persisted var descriptionText: String?
    @Persisted var dateScheduled: Date
    @Persisted var dateCreated: Date
    var isPassed: Bool {
        dateScheduled < Date()
    }
    
    convenience init(name: String, descriptionText: String? = nil, dateScheduled: Date, dateCreated: Date = Date()) {
        self.init()
        self.name = name
        self.descriptionText = descriptionText
        self.dateScheduled = dateScheduled
        self.dateCreated = dateCreated
    }
    
    static func generate() -> CountDown {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let newYearDate = formatter.date(from: "2023-12-31") ?? Date()
        
        let countDown = CountDown()
        countDown.name = "New year"
        countDown.descriptionText = "Prepare everything before this count down runs out :)"
        countDown.dateScheduled = newYearDate
        
        return countDown
    }
}
