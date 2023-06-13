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
    var elements = [String]()
    
    var mindMap: UIMindMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMindMapLayout()
        webview.loadHTMLString(build(html: elements), baseURL: nil)
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
        /*🤔 🤔 🤔*/
        mindMap.add(sender.tag == 0 ? Node(title: "Head", color: .systemGreen) : Node(title: "Body", color: .systemRed))
        elements.append("<h1>Hello CAOCAP</h1>")
        print(elements.split(separator: ""))
        webview.loadHTMLString(build(html: elements), baseURL: nil)
    }
    
    func build(html: [String]) -> String {
        var result = ""
        for element in elements {
            result += element
        }
        return result
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
