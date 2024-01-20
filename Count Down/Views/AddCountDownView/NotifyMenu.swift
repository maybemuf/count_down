//
//  NotifyContextMenu.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 19.01.2024.
//

import SwiftUI

struct NotifyMenu: View {
    let selectedAlertOption: AlertOption
    let onAlertOptionSelected: (AlertOption) -> Void
    var body: some View {
        HStack {
            Menu("Alert") {
                ForEach(AlertOption.allCases, id: \.rawValue) { alertOption in
                    Button() {
                        if alertOption != .none {
                            LocalNotificationService().request()
                        }
                        let content = UNMutableNotificationContent()
                                        content.title = "Notification title."
                                        content.subtitle = "Notification content."
                                        content.sound = UNNotificationSound.default
                                        
                                        
                                        // show this notification five seconds from now
                                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                        
                                        
                                        // choose a random identifier
                                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                        
                                        // add our notification request
                                        UNUserNotificationCenter.current().add(request)
                        
                        onAlertOptionSelected(alertOption)
                    } label: {
                        if alertOption == selectedAlertOption {
                            Label(alertOption.rawValue, systemImage: "checkmark")
                        } else {
                            Text(alertOption.rawValue)
                        }
                    }
                    if alertOption == .none { Divider() }
                }
                
            }
            
            Spacer()
            
            Text(selectedAlertOption.rawValue)
        }
    }
}

#Preview {
    NotifyMenu(selectedAlertOption: .none) { alertOption in
        print(alertOption)
    }
}
