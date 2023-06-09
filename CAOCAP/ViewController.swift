//
//  ViewController.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 03/06/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    var mindMap: MindMapScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mindMap = MindMapScrollView(frame: view.frame, tree: NodeTree())
        view.insertSubview(mindMap, at: 0)
        NSLayoutConstraint.activate([
            mindMap.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mindMap.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mindMap.topAnchor.constraint(equalTo: view.topAnchor),
            mindMap.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        webview.loadHTMLString("<h1>Hello CAOCAP</h1>", baseURL: nil)
    }
    
    @IBAction func didPressAddNode(_ sender: UIButton) {
        print("\(#function)ing...")
        /*🤔 🤔 🤔*/
        mindMap.nodeTreeHistory.removeAll()
        redoButton.isEnabled = false
        undoButton.isEnabled = true
        let node = sender.tag == 0 ? Node(title: "Head", color: .systemGreen) : Node(title: "Body", color: .systemPink)
        mindMap.nodeTree.root.add(child: node)
        print(mindMap.nodeTree.root.description)
        mindMap.update()
    }
    
    @IBAction func didPressUndo(_ sender: UIButton) {
        print("\(#function)ing...")
        /*🤔 🤔 🤔*/
        if mindMap.nodeTree.root.children.count > 1 {
            mindMap.nodeTree.root.removeLastNode()
            print(mindMap.nodeTree.root.children.count)
            undoButton.isEnabled = mindMap.nodeTree.root.children.count > 1
            redoButton.isEnabled = true
            mindMap.nodeTreeHistory.append(mindMap.nodeTree)
            mindMap.update()
        }
    }
    
    @IBAction func didPressRedo(_ sender: UIButton) {
        print("\(#function)ing...")
        /*🤔 🤔 🤔*/
        if !mindMap.nodeTreeHistory.isEmpty {
            let recoveredNodeTree = mindMap.nodeTreeHistory.removeFirst()
            mindMap.nodeTree = recoveredNodeTree
            redoButton.isEnabled = !mindMap.nodeTreeHistory.isEmpty
            mindMap.update()
        }
    }
    
}
