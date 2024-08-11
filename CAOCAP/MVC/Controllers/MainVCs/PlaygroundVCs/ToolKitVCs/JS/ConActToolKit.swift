//
//  ConActToolKit.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 11/08/2024.
//


import UIKit

class ConActToolKit: ToolKitVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func newState(state: ReduxState) {
        super.newState(state: state)
    }
    
    /// Handles the addition of an action node in the JS MindMap.
    @IBAction func didPressAddAction(_ sender: UIButton) {
        print("\(#function)ing...")
        // TODO: Implement action node addition logic.
    }
    
    /// Handles the addition of a condition node in the JS MindMap.
    @IBAction func didPressAddCondition(_ sender: UIButton) {
        print("\(#function)ing...")
        // TODO: Implement condition node addition logic.
    }
}
