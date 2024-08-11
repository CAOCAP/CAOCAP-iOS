//
//  ToolKitVC.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 10/08/2024.
//

import UIKit
import ReSwift

class ToolKitVC: UIViewController, StoreSubscriber, Storyboarded {

    
    /// The current project being edited in the playground.
    var project: Project?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /// Subscribes to the Redux store when the view appears.
    override func viewWillAppear(_ animated: Bool) {
        ReduxStore.subscribe(self)
    }
    
    /// Unsubscribes from the Redux store when the view disappears.
    override func viewWillDisappear(_ animated: Bool) {
        ReduxStore.unsubscribe(self)
    }
    
    /// Updates the UI based on the new state from the Redux store.
    ///
    /// - Parameter state: The new state from the Redux store.
    func newState(state: ReduxState) {
        updateProjectIfNeeded(from: state)
    }
    
    // MARK: - Helper Functions
    
    /// Updates the project reference if it is not already set.
    ///
    /// - Parameter state: The new state from the Redux store.
    private func updateProjectIfNeeded(from state: ReduxState) {
        if project == nil {
            project = state.openedProject
        }
    }

}
