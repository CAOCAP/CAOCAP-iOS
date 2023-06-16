//
//  MindMapVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 03/06/2023.
//

import UIKit
import WebKit

class MindMapVC: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var keyboardStack: UIStackView!
    var mindMap: UIMindMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardGestureRecognizer()
        setupMindMapLayout()
        webview.loadHTMLString(mindMap.nodeTree.root.dom, baseURL: nil)
    }
    
    func setupKeyboardGestureRecognizer() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        downSwipe.direction = .down
        keyboardView.addGestureRecognizer(upSwipe)
        keyboardView.addGestureRecognizer(downSwipe)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
                UIView.animate(withDuration: 0.15) { 
                    if self.keyboardStack.arrangedSubviews[12].isHidden {
                        //skip 1-10
                        for n in 11...12 {
                            let view = self.keyboardStack.arrangedSubviews[n]
                            view.alpha = 1
                            view.isHidden = false
                        }
                    } else if self.keyboardStack.arrangedSubviews[1].isHidden {
                        //skip 3,4,5,8,9
                        for n in 1...12 {
                            if [3,4,5,8,9].contains(n) { continue }
                            let view = self.keyboardStack.arrangedSubviews[n]
                            view.alpha = 1
                            view.isHidden = false
                        }
                    } else {
                        for n in 1...12 {
                            let view = self.keyboardStack.arrangedSubviews[n]
                            view.alpha = 1
                            view.isHidden = false
                        }
                    }
                }
                loadViewIfNeeded()
            case .down:
                UIView.animate(withDuration: 0.15) {
                    if self.keyboardStack.arrangedSubviews[1].isHidden {
                        for n in 11...12 {
                            let view = self.keyboardStack.arrangedSubviews[n]
                            view.alpha = 0
                            view.isHidden = true
                        }
                    } else if self.keyboardStack.arrangedSubviews[3].isHidden {
                        for n in 1...10 {
                            let view = self.keyboardStack.arrangedSubviews[n]
                            view.alpha = 0
                            view.isHidden = true
                        }
                    } else {
                        for n in 3...9 {
                            if [6,7].contains(n) { continue }
                            let view = self.keyboardStack.arrangedSubviews[n]
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
    
    
    @IBAction func didPressArrow(_ sender: UIButton) {
        mindMap.updateSelectedNode(Direction(rawValue: sender.tag))
    }
    
    @IBAction func didPressAddNode(_ sender: UIButton) {
        print("\(#function)ing...")
        let newNode: Node
        switch sender.tag {
        case 1:
            newNode = Node(title: "Head", color: .systemGreen)
        case 2:
            newNode = Node(title: "Body", color: .systemPink)
        case 3:
            newNode = Node(title: "Meta", color: .purple)
        case 4:
            newNode = Node(title: "Title", color: .purple)
        case 5:
            newNode = Node(title: "Style", color: .purple)
        case 6:
            newNode = Node(title: "Button", color: .systemGreen)
        case 7:
            newNode = Node(title: "Div", color: .systemPink)
        case 8:
            newNode = Node(title: "Image", color: .purple) // 🤔
        case 9:
            newNode = Node(title: "Script", color: .purple)
        case 10:
            newNode = Node(title: "H1", color: .systemGray)
        default:
            newNode = Node(title: "P", color: .systemGray)
        }
        mindMap.add(newNode)
        print(mindMap.nodeTree.root.dom)
        webview.loadHTMLString(mindMap.nodeTree.root.dom, baseURL: nil)
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
