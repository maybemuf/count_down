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
        isEditingExisting = true
        editedCountDownId = countDown.id
        nameErrorText = ""
        dateErrorText = ""
    }
}

final class AddCountDownViewModel: StateBindingViewModel<AddCountDownState> {
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
            dateScheduled: state.dateTo
        )
        
        do {
            try realm?.write {
                if state.isEditingExisting {
                    let countDownToEdit = realm?.object(ofType: CountDown.self, forPrimaryKey: state.editedCountDownId)
                    if let countDownToEdit {
                        countDownToEdit.name = state.name
                        countDownToEdit.descriptionText = state.description
                        countDownToEdit.dateScheduled = state.dateTo
                    }
                } else {
                    realm?.add(countDown)
                }
                
                onAdded()
            }
        } catch {
            print(error.localizedDescription)
        }
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
