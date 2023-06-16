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
    
    @IBOutlet weak var keyboardStackView: UIStackView!
    var mindMap: UIMindMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMindMapLayout()
        webview.loadHTMLString(mindMap.nodeTree.root.dom, baseURL: nil)
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
