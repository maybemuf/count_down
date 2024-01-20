//
//  LocalNotificationService.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 19.01.2024.
//

import Foundation
import UserNotifications

class LocalNotificationService {
    func request() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Permission approved!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeRequest(for identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func scheduleAlert(for countDown: CountDown, updating: Bool = false) {
        let date = countDown.dateScheduled
        let alert = countDown.alert!
        
        if updating, let identifer = countDown.alert?.id.stringValue {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifer])
        }
        
        let content = UNMutableNotificationContent()
        content.title = countDown.name
        content.subtitle = alert.alertOption.getDescriptionText(for: countDown.name)
        content.sound = .default
        let addingComponent = DateComponents(minute: -alert.alertOption.minutesUntil)
        guard let targetedTime = Calendar.current.date(byAdding: addingComponent, to: date) else { return }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetedTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let reqest = UNNotificationRequest(identifier: alert.id.stringValue, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(reqest)
    }
}
