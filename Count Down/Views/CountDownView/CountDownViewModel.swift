//
//  CountDownViewModel.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 28.12.2023.
//

import Foundation
import RealmSwift
import Combine

private let isShowingCompletedKey = "isShowingCompletedKey"

struct CountDownState: Equatable {
    @ObservedResults(CountDown.self) var countDowns
    var filteredCountDownds = [CountDown]()
    var isShowingCompleted: Bool = UserDefaults.standard.bool(forKey: isShowingCompletedKey)
}

extension CountDownState {
    static func == (lhs: CountDownState, rhs: CountDownState) -> Bool {
        lhs.countDowns == rhs.countDowns
    }
}

class CountDownViewModel: StateBindingViewModel<CountDownState> {
    let realm = try? Realm()
    var anyCancellable: AnyCancellable? = nil
      
    init() {
        super.init(initialState: CountDownState())
    }
    
    deinit {
        anyCancellable?.cancel()
    }
    
    public func getCountDowns() {
        anyCancellable = state.countDowns.objectWillChange.sink {[weak self] (_) in
            self?.updateFiltered()
            self?.objectWillChange.send()
        }
    }
    
    public func deleteCountDown(_ countDown: CountDown) {
        do {
            try realm?.write {
                realm?.delete(countDown)
                updateFiltered()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func onStateChange(_ keyPath: PartialKeyPath<CountDownState>) {
        UserDefaults.standard.set(state.isShowingCompleted, forKey: isShowingCompletedKey)
        updateFiltered()
    }
    
    private func updateFiltered() {
        let filtered = state.isShowingCompleted
            ? Array(state.countDowns)
            : Array(state.countDowns.where {$0.dateScheduled > Date()})
        
        update(\.filteredCountDownds, to: filtered)
    }
}
