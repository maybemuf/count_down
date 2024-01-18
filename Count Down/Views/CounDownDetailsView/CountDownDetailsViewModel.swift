//
//  CountDownDetailsViewModel.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 29.12.2023.
//

import Foundation
import RealmSwift

struct CountDownDetailsState: Equatable {
    var timeDifference: DateComponents?
    @ObservedRealmObject var countDown: CountDown
    var isEditing = false
}

extension CountDownDetailsState {
    static func == (lhs: CountDownDetailsState, rhs: CountDownDetailsState) -> Bool {
        lhs.countDown == rhs.countDown
    }
}

class CountDownDetailsViewModel: StateBindingViewModel<CountDownDetailsState> {
    var timer: Timer?
    
    var isCompleted: Bool {
        state.countDown.dateScheduled <= Date()
    }
    
    func setupCountDown() {
        print("setup countDown")
        if isCompleted {
            self.update(\.timeDifference, to: DateComponents())
        } else {
            updateTimeDifference()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                self.updateTimeDifference()
            }
        }
    }
    
    func startEditing() {
        timer?.pause()
        update(\.isEditing, to: true)
    }
    
    private func updateTimeDifference() {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(), to: self.state.countDown.dateScheduled)
        
        self.update(\.timeDifference, to: dateComponents)
    }
    
    override func onStateChange(_ keyPath: PartialKeyPath<CountDownDetailsState>) {
        if keyPath == \.isEditing {
            if !(state[keyPath: keyPath] as! Bool) {
                updateTimeDifference()
                timer?.resume()
            }
        }
    }
    
}
