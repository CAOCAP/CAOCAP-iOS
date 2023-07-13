//
//  MindMapVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 03/06/2023.
//

import UIKit
import WebKit

class MindMapVC: UIViewController, Storyboarded {
    
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
    
    @IBOutlet weak var jsView: UIView!
    
    var mindMap: UIMindMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resizeGR = UIPanGestureRecognizer(target: self, action: #selector(handleResizingWebView(sender:)))
        resizeIcon.addGestureRecognizer(resizeGR)
        
        setupToolsViewGestureRecognizer()
        setupMindMapLayout()
        
        loadWebView()
    }
    
    func loadWebView() {
        let htmlCode = #"""
        <!DOCTYPE html>
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <script src="https://cdn.tailwindcss.com"></script>
            </head>
            \#(mindMap.nodeTree.body.dom)
        </html>
        """#
        webView.loadHTMLString(htmlCode, baseURL: nil)
        print(htmlCode)
    }
    
    func setupMindMapLayout() {
        mindMap = UIMindMap(frame: view.frame, tree: NodeTree())
        mindMap.mindMapDelegate = self
        view.insertSubview(mindMap, at: 0)
        NSLayoutConstraint.activate([
            mindMap.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mindMap.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mindMap.topAnchor.constraint(equalTo: view.topAnchor),
            mindMap.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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
    
    @IBAction func didPressAddNode(_ sender: UIButton) {
        print("\(#function)ing...")
        /* warning : you are about to witness ugly code*/
        let newNode: Node
        switch sender.tag {
        case 1:
            newNode = Node(title: "Span", color: .systemGreen)
        case 2:
            newNode = Node(title: "Div", color: .systemPink)
        case 3:
            newNode = Node(title: "Button", color: .systemPurple, text: "Click Me!")
        case 4:
            newNode = Node(title: "A", color: .systemPurple, text: "Visit W3Schools.com!")
        case 5:
            newNode = Node(title: "Input", color: .systemPurple)
        case 6:
            newNode = Node(title: "Header", color: .systemBlue)
        case 7:
            newNode = Node(title: "Main", color: .systemBlue)
        case 8:
            newNode = Node(title: "Footer", color: .systemBlue)
        case 9:
            newNode = Node(title: "Article", color: .systemBlue)
        case 10:
            newNode = Node(title: "Section", color: .systemBlue)
        case 11:
            newNode = Node(title: "Aside", color: .systemBlue)
        case 12:
            newNode = Node(title: "Canvas", color: .systemBlue)
        case 13:
            newNode = Node(title: "Nav", color: .systemBlue)
        case 14:
            newNode = Node(title: "Center", color: .systemBlue)
        case 15:
            newNode = Node(title: "TextArea", color: .systemTeal, text: "The HyperText Markup Language or HTML is the standard markup language for documents designed to be displayed in a web browser. It is often assisted by technologies such as Cascading Style Sheets and scripting languages such as JavaScript.")
        case 16:
            newNode = Node(title: "Form", color: .systemTeal)
        case 17:
            newNode = Node(title: "Label", color: .systemTeal, text: "First name:")
        case 18:
            newNode = Node(title: "Option", color: .systemTeal, text: "CAOCAP")
        case 19:
            newNode = Node(title: "Legend", color: .systemTeal, text: "Personalia:")
        case 20:
            newNode = Node(title: "Select", color: .systemTeal)
        case 21:
            newNode = Node(title: "FieldSet", color: .systemTeal)
        case 22:
            newNode = Node(title: "OptGroup", color: .systemTeal)
        case 23:
            newNode = Node(title: "Output", color: .systemTeal)
        case 24:
            newNode = Node(title: "Video", color: .systemYellow)
        case 25:
            newNode = Node(title: "Img", color: .systemYellow)
        case 26:
            newNode = Node(title: "Audio", color: .systemYellow)
        case 27:
            newNode = Node(title: "Source", color: .systemYellow)
        case 28:
            newNode = Node(title: "UL", color: .systemGray)
        case 29:
            newNode = Node(title: "OL", color: .systemGray)
        case 30:
            newNode = Node(title: "LI", color: .systemGray, text: "Coffee")
        case 31:
            newNode = Node(title: "BR", color: .systemGray)
        case 32:
            newNode = Node(title: "HR", color: .systemGray)
        case 33:
            newNode = Node(title: "H1", color: .systemGray2, text: "Hello CAOCAP!")
        case 34:
            newNode = Node(title: "P", color: .systemGray2, text: "At w3schools.com you will learn how to make a website. They offer free tutorials in all web development technologies.")
        case 35:
            newNode = Node(title: "B", color: .systemGray2, text: "this is bold text")
        case 36:
            newNode = Node(title: "I", color: .systemGray2, text: "displayed in italic")
        case 37:
            newNode = Node(title: "U", color: .systemGray2, text: "content underline")
        default:
            newNode = Node(title: "S", color: .systemGray2, text: "content deleted")
        }
        mindMap.add(newNode)
        loadWebView()
        /*🤔 🤔 🤔*/
    }
    
    @IBAction func didPressUndo(_ sender: UIButton) {
        print("\(#function)ing...")
        //mindMap.undo()🤔
    }
    
    @IBAction func didPressRedo(_ sender: UIButton) {
        print("\(#function)ing...")
        //mindMap.redo()🤔
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
        print(sender.text)
    }
}
