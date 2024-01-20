//
//  AddCountDownViewModel.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 24.12.2023.
//

import Foundation
import RealmSwift

struct AddCountDownState: Equatable {
    var name = ""
    var description = ""
    var nameErrorText = ""
    var dateErrorText = ""
    var dateTo = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    var alertOption = AlertOption.none
    var editedCountDownId: ObjectId?
    var isEditingExisting = false
    
    init(name: String = "", description: String = "", nameErrorText: String = "", dateErrorText: String = "", dateTo: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date(), isEditingExisting: Bool = false) {
        self.name = name
        self.description = description
        self.nameErrorText = nameErrorText
        self.dateErrorText = dateErrorText
        self.dateTo = dateTo
        self.isEditingExisting = isEditingExisting
        self.editedCountDownId = nil
    }
    
    init(countDown: CountDown) {
        name = countDown.name
        description = countDown.descriptionText ?? ""
        dateTo = countDown.dateScheduled
        alertOption = countDown.alert?.alertOption ?? .none
        isEditingExisting = true
        editedCountDownId = countDown.id
        nameErrorText = ""
        dateErrorText = ""
    }
}

final class AddCountDownViewModel: StateBindingViewModel<AddCountDownState> {
    let localNotificationService = LocalNotificationService()
    let realm = try? Realm()
    
    init() {
        super.init(initialState: AddCountDownState())
    }
    
    init(countDown: CountDown) {
        super.init(initialState: AddCountDownState(countDown: countDown))
    }
    
    var fromToday: ClosedRange<Date> {
        let currentDate = Date()
        let oneMinuteAhead = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate) ?? currentDate
        let fiveYearsAhead = Calendar.current.date(byAdding: .year, value: 5, to: currentDate) ?? currentDate
            
        return oneMinuteAhead...fiveYearsAhead
    }
    
    func addCountDown(onAdded: () -> Void) {
        guard validateName() && validateDate() else { return }
        
        let countDown = CountDown(
            name: state.name,
            descriptionText: state.description,
            dateScheduled: state.dateTo,
            option: state.alertOption
        )
        
        do {
            try realm?.write {
                if state.isEditingExisting {
                    if let countDownToEdit = realm?.object(ofType: CountDown.self, forPrimaryKey: state.editedCountDownId) {
                        countDownToEdit.name = state.name
                        countDownToEdit.descriptionText = state.description
                        countDownToEdit.dateScheduled = state.dateTo
                        countDownToEdit.alert?.alertOption = state.alertOption
                        
                        if state.alertOption != .none {
                            localNotificationService.scheduleAlert(for: countDown, updating: true)
                        }
                    }
                } else {
                    realm?.add(countDown)
                    if state.alertOption != AlertOption.none {
                        localNotificationService.scheduleAlert(for: countDown)
                    }
                }
                
                onAdded()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateAlertOption(with option: AlertOption) {
        update(\.alertOption, to: option)
    }
    
    private func validateName() -> Bool {
        if state.name.isEmpty {
            update(\.nameErrorText, to: "Name is required")
            return false
        } else {
            update(\.nameErrorText, to: "")
            return true
        }
    }
    private func validateDate() -> Bool {
        if state.dateTo < Date() {
            update(\.dateErrorText, to: "Date shouldn't be in the past")
            return false
        } else {
            update(\.dateErrorText, to: "")
            return true
        }
    }
}
