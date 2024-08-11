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
    
    // MARK: - HTML Keyboard Button Layout
    
    func keyboardLayout(size: SizeType) {
        let maxIndex = structureStackView.arrangedSubviews.count - 1
        var filteredRows = [UIView]()
        switch size {
        case .none:
            //hide all
            structureStackView.arrangedSubviews.forEach { row in
                row.isHidden = true
            }
        case .small:
            // only show 6,7
            structureStackView.arrangedSubviews.enumerated().forEach { index, row in
                row.isHidden = ![6,7].contains(index)
            }
        case .medium:
            //show all but not 3,4
            structureStackView.arrangedSubviews.enumerated().forEach { index, row in
                row.isHidden = [3,4].contains(index)
            }
        case .large:
            //show all
            structureStackView.arrangedSubviews.forEach { row in
                row.isHidden = false
            }
        }
        
    }
}
