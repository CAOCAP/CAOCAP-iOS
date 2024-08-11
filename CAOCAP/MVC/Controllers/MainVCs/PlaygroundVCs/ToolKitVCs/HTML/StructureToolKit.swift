//
//  StructureToolKit.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 10/08/2024.
//

import UIKit

class StructureToolKit: ToolKitVC {
    
    //MARK: HTML Keyboard Outlets
    @IBOutlet weak var structureKeyboardView: UIView!
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
//            htmlMindMap.add(tag: htmlTags[sender.tag]) TODO: -
        }
    }
    
}
