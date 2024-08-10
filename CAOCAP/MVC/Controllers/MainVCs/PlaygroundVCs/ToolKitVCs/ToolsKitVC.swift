//
//  ToolsKitVC.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 10/08/2024.
//

import UIKit
import ReSwift

class ToolsKitVC: UIViewController, StoreSubscriber {

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
        
    }

}
