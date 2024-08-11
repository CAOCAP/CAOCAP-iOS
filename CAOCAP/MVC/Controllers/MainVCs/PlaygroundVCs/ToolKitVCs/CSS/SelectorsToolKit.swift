//
//  SelectorsToolKit.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 10/08/2024.
//

import UIKit

class SelectorsToolKit: ToolKitVC {
    
    
    //MARK: CSS Keyboard Outlets
    @IBOutlet weak var selectorsKeyboardView: UIView!
    @IBOutlet weak var selectorsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func newState(state: ReduxState) {
        super.newState(state: state)
    }
}
