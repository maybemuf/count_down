//
//  StateBindingViewModel.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 24.12.2023.
//

import Foundation
import SwiftUI

open class StateBindingViewModel<State: Equatable>: ObservableObject {
    
    @Published public private(set) var state: State
    
    public init(initialState: State) {
        self.state = initialState
    }
    
    
    public func binding<Value>(
        _ keyPath: WritableKeyPath<State, Value>
    ) -> Binding<Value> where Value: Equatable {
        .init(
            get: { self.state[keyPath: keyPath] },
            set: { [weak self] newValue in
                
                guard let self = self else { return }
                
                guard self.stateWillChangeValue(keyPath, newValue: newValue) else { return }
                
                let oldValue = self.state[keyPath: keyPath]
                guard newValue != oldValue else { return }
                self.state[keyPath: keyPath] = newValue
                self.onStateChange(keyPath)
            }
        )
    }
    
    public func update<Value>(
        _ keyPath: WritableKeyPath<State, Value>,
        to newValue: Value
    ) where Value: Equatable {
        self.state[keyPath: keyPath] = newValue
    }
    
    open func stateWillChangeValue<Value>(
        _ keyPath: PartialKeyPath<State>,
        newValue: Value
    ) -> Bool where Value: Equatable {
        return true
    }
    
    open func onStateChange(_ keyPath: PartialKeyPath<State>) {}
}
