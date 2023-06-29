//
//  MindMapVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 03/06/2023.
//

import UIKit
import WebKit

class MindMapVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var resizeIcon: UIImageView!
    @IBOutlet weak var webViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var htmlKeyboard: UIStackView!
    @IBOutlet weak var cssKeyboard: UIStackView!
    @IBOutlet weak var jsKeyboard: UIStackView!
    var mindMap: UIMindMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let resizeGR = UIPanGestureRecognizer(target: self, action: #selector(handleResizingWebView(sender:)))
        resizeIcon.addGestureRecognizer(resizeGR)
        
        setupKeyboardGestureRecognizer()
        setupMindMapLayout()
        webView.loadHTMLString(mindMap.nodeTree.root.dom, baseURL: nil)
    }
    
    func setupMindMapLayout() {
        mindMap = UIMindMap(frame: view.frame, tree: NodeTree())
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
            print(touchPoint)
        default:
            print("ended")
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
    
    func setupKeyboardGestureRecognizer() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        rightSwipe.direction = .right
        leftSwipe.direction = .left
        upSwipe.direction = .up
        downSwipe.direction = .down
        keyboardView.addGestureRecognizer(rightSwipe)
        keyboardView.addGestureRecognizer(leftSwipe)
        keyboardView.addGestureRecognizer(upSwipe)
        keyboardView.addGestureRecognizer(downSwipe)
    }
    
    
    @objc func handleKeyboardSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                if !htmlKeyboard.isHidden {
                    htmlKeyboard.isHidden = true
                    jsKeyboard.isHidden = false
                } else if !jsKeyboard.isHidden {
                    jsKeyboard.isHidden = true
                    cssKeyboard.isHidden = false
                } else {
                    cssKeyboard.isHidden = true
                    htmlKeyboard.isHidden = false
                }
            case .left:
                if !htmlKeyboard.isHidden {
                    htmlKeyboard.isHidden = true
                    cssKeyboard.isHidden = false
                } else if !jsKeyboard.isHidden {
                    jsKeyboard.isHidden = true
                    htmlKeyboard.isHidden = false
                } else {
                    cssKeyboard.isHidden = true
                    jsKeyboard.isHidden = false
                }
            case .up where !htmlKeyboard.isHidden:
                UIView.animate(withDuration: 0.15) {
                    if self.htmlKeyboard.arrangedSubviews[11].isHidden {
                        //skip 0-9
                        for n in 10...11 {
                            let view = self.htmlKeyboard.arrangedSubviews[n]
                            view.alpha = 1
                            view.isHidden = false
                        }
                    } else if self.htmlKeyboard.arrangedSubviews[0].isHidden {
                        //skip 2,3,4,7,8
                        for n in 0...11 {
                            if [2,3,4,7,8].contains(n) { continue }
                            let view = self.htmlKeyboard.arrangedSubviews[n]
                            view.alpha = 1
                            view.isHidden = false
                        }
                    } else {
                        self.webViewWidthConstraint.constant = 80
                        for n in 0...11 {
                            let view = self.htmlKeyboard.arrangedSubviews[n]
                            view.alpha = 1
                            view.isHidden = false
                        }
                    }
                }
                loadViewIfNeeded()
            case .down where !htmlKeyboard.isHidden:
                UIView.animate(withDuration: 0.15) {
                    if self.htmlKeyboard.arrangedSubviews[0].isHidden {
                        for n in 10...11 {
                            let view = self.htmlKeyboard.arrangedSubviews[n]
                            view.alpha = 0
                            view.isHidden = true
                        }
                    } else if self.htmlKeyboard.arrangedSubviews[2].isHidden {
                        for n in 0...9 {
                            let view = self.htmlKeyboard.arrangedSubviews[n]
                            view.alpha = 0
                            view.isHidden = true
                        }
                    } else {
                        self.webViewWidthConstraint.constant = 160
                        for n in 2...8 {
                            if [5,6].contains(n) { continue }
                            let view = self.htmlKeyboard.arrangedSubviews[n]
                            view.alpha = 0
                            view.isHidden = true
                        }
                    }
                }
                loadViewIfNeeded()
            default:
                break
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
            newNode = Node(title: "Head", color: .systemGreen)
        case 2:
            newNode = Node(title: "Body", color: .systemPink)
        case 3:
            newNode = Node(title: "Meta", color: .systemPurple)
        case 4:
            newNode = Node(title: "Title", color: .systemPurple, text: "MyBlog")
        case 5:
            newNode = Node(title: "Style", color: .systemPurple)
        case 6:
            newNode = Node(title: "Canvas", color: .systemBlue)
        case 7:
            newNode = Node(title: "Main", color: .systemBlue)
        case 8:
            newNode = Node(title: "Nav", color: .systemBlue)
        case 9:
            newNode = Node(title: "Aside", color: .systemBlue)
        case 10:
            newNode = Node(title: "Article", color: .systemBlue)
        case 11:
            newNode = Node(title: "Header", color: .systemBlue)
        case 12:
            newNode = Node(title: "Footer", color: .systemBlue)
        case 13:
            newNode = Node(title: "Section", color: .systemBlue)
        case 14:
            newNode = Node(title: "Button", color: .systemBlue, text: "Click Me!")
        case 15:
            newNode = Node(title: "Div", color: .systemBlue)
        case 16:
            newNode = Node(title: "Img", color: .systemBlue)
        case 17:
            newNode = Node(title: "Script", color: .systemBlue)
        case 18:
            newNode = Node(title: "Input", color: .systemTeal)
        case 19:
            newNode = Node(title: "Form", color: .systemTeal)
        case 20:
            newNode = Node(title: "Output", color: .systemTeal)
        case 21:
            newNode = Node(title: "Label", color: .systemTeal, text: "First name:")
        case 22:
            newNode = Node(title: "Option", color: .systemTeal, text: "CAOCAP")
        case 23:
            newNode = Node(title: "Legend", color: .systemTeal, text: "Personalia:")
        case 24:
            newNode = Node(title: "Select", color: .systemTeal)
        case 25:
            newNode = Node(title: "FieldSet", color: .systemTeal)
        case 26:
            newNode = Node(title: "OptGroup", color: .systemTeal)
        case 27:
            newNode = Node(title: "TextArea", color: .systemTeal, text: "The HyperText Markup Language or HTML is the standard markup language for documents designed to be displayed in a web browser. It is often assisted by technologies such as Cascading Style Sheets and scripting languages such as JavaScript.")
        case 28:
            newNode = Node(title: "Video", color: .systemYellow)
        case 29:
            newNode = Node(title: "Source", color: .systemYellow)
        case 30:
            newNode = Node(title: "Audio", color: .systemYellow)
        case 31:
            newNode = Node(title: "H1", color: .systemGray, text: "Hello CAOCAP!")
        case 32:
            newNode = Node(title: "P", color: .systemGray, text: "At w3schools.com you will learn how to make a website. They offer free tutorials in all web development technologies.")
        case 33:
            newNode = Node(title: "Span", color: .systemGray, text: "caocap")
        case 34:
            newNode = Node(title: "BR", color: .systemGray)
        case 35:
            newNode = Node(title: "A", color: .systemGray, text: "Visit W3Schools.com!")
        case 36:
            newNode = Node(title: "UL", color: .systemGray)
        case 37:
            newNode = Node(title: "OL", color: .systemGray)
        case 38:
            newNode = Node(title: "LI", color: .systemGray, text: "Coffee")
        case 39:
            newNode = Node(title: "EM", color: .systemGray, text: "displayed in italic")
        case 40:
            newNode = Node(title: "B", color: .systemGray, text: "this is bold text")
        default:
            newNode = Node(title: "I", color: .systemGray, text: "alternate voice or mood")
        }
        mindMap.add(newNode)
        print(mindMap.nodeTree.root.dom)
        webView.loadHTMLString(mindMap.nodeTree.root.dom, baseURL: nil)
        /*🤔 🤔 🤔*/
    }
    
    @IBAction func didPressUndo(_ sender: UIButton) {
        print("\(#function)ing...")
        /*🤔 🤔 🤔*/
        //        mindMap.undo()
        
    }
    
    @IBAction func didPressRedo(_ sender: UIButton) {
        print("\(#function)ing...")
        /*🤔 🤔 🤔*/
        //        mindMap.redo()
    }
    
}
