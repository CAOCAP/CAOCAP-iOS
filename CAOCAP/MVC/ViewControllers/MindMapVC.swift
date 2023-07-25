//
//  MindMapVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 03/06/2023.
//

import UIKit
import WebKit
import ReSwift
import SnapKit
import SwiftSoup

class MindMapVC: UIViewController, Storyboarded {
    
    var project: Project?
    
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var resizeIcon: UIImageView!
    @IBOutlet weak var webViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    @IBOutlet weak var toolsView: UIView!
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var htmlView: UIView!
    @IBOutlet weak var htmlKeyboard: UIStackView!
    
    @IBOutlet weak var attributesView: UIView!
    @IBOutlet weak var attributesStackView: UIStackView!
    @IBOutlet weak var attributesSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var backgroundColorWell: UIColorWell!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    
    @IBOutlet weak var jsView: UIView!
    
    var mindMap: UIMindMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resizeGR = UIPanGestureRecognizer(target: self, action: #selector(handleResizingWebView(sender:)))
        resizeIcon.addGestureRecognizer(resizeGR)
        
        setupToolsViewGestureRecognizer()
        setupMindMapLayout()
    }
    
    func loadWebView() {
        guard let document = project?.document else { return }
        do {
            let htmlCode = try document.outerHtml()
            print("loadWebView:", htmlCode)
            webView.loadHTMLString( htmlCode, baseURL: nil)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }
    
    
    func setupMindMapLayout() {
        mindMap = UIMindMap(frame: view.frame)
        mindMap.mindMapDelegate = self
        view.insertSubview(mindMap, at: 0)
        mindMap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func handleResizingWebView(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            let touchPoint = sender.location(in: view).x - 20
            if touchPoint > 60 && touchPoint < 240 {
                webViewWidthConstraint.constant =
                touchPoint
            }
        default:
            if webViewWidthConstraint.constant < 90 {
                webViewWidthConstraint.constant = 80
            } else if webViewWidthConstraint.constant >= 90 && webViewWidthConstraint.constant < 130 {
                webViewWidthConstraint.constant = 120
            } else if webViewWidthConstraint.constant >= 130 && webViewWidthConstraint.constant < 170 {
                webViewWidthConstraint.constant = 160
            } else {
                webViewWidthConstraint.constant = 200
            }
        }
    }
    
    func setupToolsViewGestureRecognizer() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        rightSwipe.direction = .right
        leftSwipe.direction = .left
        upSwipe.direction = .up
        downSwipe.direction = .down
        toolsView.addGestureRecognizer(rightSwipe)
        toolsView.addGestureRecognizer(leftSwipe)
        toolsView.addGestureRecognizer(upSwipe)
        toolsView.addGestureRecognizer(downSwipe)
    }
    
    @objc func handleKeyboardSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                if !htmlView.isHidden {
                    htmlView.isHidden = true
                    jsView.isHidden = false
                } else if !jsView.isHidden {
                    jsView.isHidden = true
                    attributesView.isHidden = false
                } else {
                    attributesView.isHidden = true
                    htmlView.isHidden = false
                }
            case .left:
                if !htmlView.isHidden {
                    htmlView.isHidden = true
                    attributesView.isHidden = false
                } else if !jsView.isHidden {
                    jsView.isHidden = true
                    htmlView.isHidden = false
                } else {
                    attributesView.isHidden = true
                    jsView.isHidden = false
                }
            case .up:
                if toolsViewHeightConstraint.constant == 40 {
                    //only show 9,10 { h=110 }
                    toolsViewHeightConstraint.constant = 110
                    for n in 9...10 {
                        let view = htmlKeyboard.arrangedSubviews[n]
                        view.alpha = 1
                        view.isHidden = false
                    }
                } else if toolsViewHeightConstraint.constant == 110 {
                    //show all but not 2,3,6,7 { h=300 }
                    toolsViewHeightConstraint.constant = 300
                    for n in 0...10 {
                        if [2,3,6,7].contains(n) { continue }
                        let view = htmlKeyboard.arrangedSubviews[n]
                        view.alpha = 1
                        view.isHidden = false
                    }
                } else if toolsViewHeightConstraint.constant == 300 {
                    //show all { h=450 }
                    webViewWidthConstraint.constant = 120
                    toolsViewHeightConstraint.constant = 450
                    for n in 0...10 {
                        let view = htmlKeyboard.arrangedSubviews[n]
                        view.alpha = 1
                        view.isHidden = false
                    }
                }
            case .down:
                if toolsViewHeightConstraint.constant == 110 {
                    //hide all { h=40 }
                    toolsViewHeightConstraint.constant = 40
                    for n in 9...10 {
                        let view = htmlKeyboard.arrangedSubviews[n]
                        view.alpha = 0
                        view.isHidden = true
                    }
                } else if toolsViewHeightConstraint.constant == 300 {
                    //only show 9,10 { h=110 }
                    toolsViewHeightConstraint.constant = 110
                    for n in 0...8 {
                        let view = htmlKeyboard.arrangedSubviews[n]
                        view.alpha = 0
                        view.isHidden = true
                    }
                } else if toolsViewHeightConstraint.constant == 450 {
                    //show all but not 2,3,6,7 { h=300 }
                    webViewWidthConstraint.constant = 160
                    toolsViewHeightConstraint.constant = 300
                    for n in 2...7 {
                        if [4,5].contains(n) { continue }
                        let view = htmlKeyboard.arrangedSubviews[n]
                        view.alpha = 0
                        view.isHidden = true
                    }
                }
            default:
                break
            }
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func didPressCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didPressArrow(_ sender: UIButton) {
        mindMap.updateSelectedNode(Direction(rawValue: sender.tag))
    }
    
    @IBAction func didPressAddElement(_ sender: UIButton) {
        print("\(#function)ing...")
        let htmlTags = [
            "",// element buttons tags start from 1
            "span","div",
            "button","a","input",
            "header","main","footer",
            "article","section",
            "aside","canvas","nav","center",
            "textArea","form","label",
            "option","legend","select",
            "fieldSet","optGroup","output",
            "video","img","audio","source",
            "ul","ol","li","br","hr",
            "h1","p","b","i","u","s",
        ]
        if sender.tag > 0 && sender.tag < htmlTags.count {
            mindMap.add(tag: htmlTags[sender.tag])
        }
    }
    
    @IBAction func didPressUndo(_ sender: UIButton) {
        print("\(#function)ing...")
        ReduxStore.dispatch(UndoAction())
    }
    
    @IBAction func didPressRedo(_ sender: UIButton) {
        print("\(#function)ing...")
        ReduxStore.dispatch(RedoAction())
    }
    
    @IBAction func didChangeAttributesViewSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            attributesStackView.arrangedSubviews[1].isHidden = false
            attributesStackView.arrangedSubviews[2].isHidden = true
            attributesStackView.arrangedSubviews[3].isHidden = true
        case 1:
            attributesStackView.arrangedSubviews[1].isHidden = true
            attributesStackView.arrangedSubviews[2].isHidden = false
            attributesStackView.arrangedSubviews[3].isHidden = true
        default:
            attributesStackView.arrangedSubviews[1].isHidden = true
            attributesStackView.arrangedSubviews[2].isHidden = true
            attributesStackView.arrangedSubviews[3].isHidden = false
        }
    }
    
    @IBAction func didChangeHiddenSwitch(_ sender: UISwitch) {
        project?.setSelectedElementHidden(sender.isOn)
    }
    
    
}

extension MindMapVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tailwindCSS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tailwindCell", for: indexPath) as? TailwindCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(title: tailwindCSS[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 30)
    }
}


extension MindMapVC: UIMindMapDelegate {
    func didRemoveNode() {
        loadWebView()
    }
}

extension MindMapVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    @IBAction func didEndEditingTextContent(_ sender: UITextField) {
        guard let project = project, let text = sender.text else { return }
        project.updateSelectedElementText(content: text) // this should be in the projectReducer
    }
}

extension MindMapVC: StoreSubscriber {
    override func viewWillAppear(_ animated: Bool) {
        ReduxStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ReduxStore.unsubscribe(self)
    }
    
    func newState(state: ReduxState) {
        if project == nil {
            project = state.openedProject
            mindMap.project = project
        }
        loadWebView()/*🤔*/
        mindMap.loadBody()
        
        projectTitle.text = project?.getDocumentTitle()
        
        if let selectedElementText = project?.getSelectedElement()?.ownText() {
            contentTextField.text = selectedElementText
        }
        
        if let selectedElementType = project?.getSelectedElementType() {
            typeTextField.text = selectedElementType
        }
        
        if let isHidden = project?.isSelectedElementHidden() {
            hiddenSwitch.isOn = isHidden
        }

        idTextField.placeholder = project?.selectedElementID
    }
}
