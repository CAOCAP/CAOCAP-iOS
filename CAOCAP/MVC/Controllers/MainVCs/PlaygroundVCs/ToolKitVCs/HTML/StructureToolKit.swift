//
//  StructureToolKit.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 10/08/2024.
//

import UIKit

enum SizeType {
    case none
    case small
    case medium
    case large
}

class StructureToolKit: ToolKitVC {
    
    
    var mindMap: UIMindMap!
    
    //MARK: Outlets
    @IBOutlet weak var structureStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func newState(state: ReduxState) {
        super.newState(state: state)
    }
    
    
    /// Changes the view displayed based on the selected segment in the StructureView segmented control.
    ///
    /// - Parameter sender: The segmented control that triggered this action.
    @IBAction func didChangeStructureViewSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            structureStackView.arrangedSubviews[1].isHidden = false
            structureStackView.arrangedSubviews[2].isHidden = true
        default:
            structureStackView.arrangedSubviews[1].isHidden = true
            structureStackView.arrangedSubviews[2].isHidden = false
        }
    }
    
    // MARK: - HTML Keyboard Button Actions
    /// Adds an HTML element to the current MindMap.
    ///
    /// - Parameter sender: The button that triggered this action. The button's tag determines the HTML element to add.
    @IBAction func didPressAddElement(_ sender: UIButton) {
        print("\(#function)ing...")
        // TODO: Consider externalizing the HTML tags array for better reusability.
        let htmlTags = [
            "span","canvas","div",
            "button","a","input",
            "textArea","form","label",
            "option","legend","select",
            "fieldSet","optGroup","output",
            "video","img","audio",
            "li","h1","p",
            "ul","br","hr",
        ]
        if sender.tag < htmlTags.count {
            mindMap.add(tag: htmlTags[sender.tag]) 
        }
    }
    
    
}
