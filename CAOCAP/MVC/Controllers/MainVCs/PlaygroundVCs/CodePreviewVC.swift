//
//  CodePreviewVC.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 19/01/1446 AH.
//

import UIKit
import ReSwift
import SwiftSoup
import STTextView

class CodePreviewVC: UIViewController, Storyboarded {

    var project: Project?
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectCodeView: UIView!
    let textView = STTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupTextView()
    }
    
    func setupTextView() {
        projectCodeView.addSubview(textView)
        textView.frame = projectCodeView.bounds
        textView.font = .monogamma(.regular, size: 15)
        textView.textColor = .green
//        textView.isEditable = false TODO: bug in the STTextView package
        textView.isHorizontallyResizable = true
        textView.highlightSelectedLine = true
        textView.showsLineNumbers = true
        textView.gutterView?.drawSeparator = true
    }
    
    func loadProjectCode() {
        guard let project = project, let document = project.document else { return }
        do {
            projectTitle.text = project.getDocumentTitle()
            textView.text = try document.outerHtml()
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }

}

extension CodePreviewVC: StoreSubscriber {
    override func viewWillAppear(_ animated: Bool) {
        ReduxStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ReduxStore.unsubscribe(self)
    }
    
    func newState(state: ReduxState) {
        if project == nil {
            project = state.openedProject
            loadProjectCode()
        }
    }
}
