import Foundation
import SwiftUI

final class Store<State, Action, Environment>: ObservableObject {
    @Published private(set) var state: State

    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>

    init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Environment>,
        environment: Environment
    ) {
        self.state = initialState
        self.environment = environment
        self.reducer = reducer
    }

    func send(_ action: Action) {
        reducer(&state, action, environment)
    }

//    func derived<DerivedState: Equatable, ExtractedAction>(
//        deriveState: @escaping (State) -> DerivedState,
//        embedAction: @escaping (ExtractedAction) -> Action
//    ) -> Store<DerivedState, ExtractedAction> {
//        let store = Store<DerivedState, ExtractedAction>(
//            initialState: deriveState(state),
//            reducer: { _, action in
//                self.send(embedAction(action))
//            }
//        )
//        $state
//            .map(deriveState)
//            .removeDuplicates()
//            .receive(on: DispatchQueue.main)
//            .assign(to: &store.$state)
//        return store
//    }
}

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> Void
