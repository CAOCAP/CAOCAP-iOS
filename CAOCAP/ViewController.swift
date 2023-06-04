//
//  ViewController.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 03/06/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var nodeTree = [UIView]()
    var undoneNodeTree = [UIView]()
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    var canvasHeightConstraint = NSLayoutConstraint()
    var canvasWidthConstraint = NSLayoutConstraint()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let canvas: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .secondarySystemFill
        return view
    }()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.setContentOffset(CGPoint(x: 100, y: 100), animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup scrollview
        view.insertSubview(scrollView, at: 0)
        scrollView.addSubview(canvas)
        
        let startingNode = AddNode()
        nodeTree.append(startingNode)
        canvas.addSubview(startingNode)
        
        canvasHeightConstraint = canvas.heightAnchor.constraint(equalToConstant: view.frame.height + 200)
        canvasWidthConstraint = canvas.widthAnchor.constraint(equalToConstant: view.frame.width + 200 )
        canvasHeightConstraint.isActive = true
        canvasWidthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            canvas.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: scrollView.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            startingNode.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: canvasWidthConstraint.constant / 2),
            startingNode.centerYAnchor.constraint(equalTo: canvas.centerYAnchor),
            startingNode.heightAnchor.constraint(equalToConstant: 60),
            startingNode.widthAnchor.constraint(equalToConstant: 150),
        ])
        
        
        
        
        //Load HTML
        webview.loadHTMLString("<h1>Hello CAOCAP</h1>", baseURL: nil)
    }
    
    func AddNode(color: UIColor = .systemBlue) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = color
        return view
    }
    
    @IBAction func didPressAddNode(_ sender: UIButton) {
        undoneNodeTree.removeAll()
        redoButton.isEnabled = false
        let newNode: UIView
        if sender.tag == 0 {
            newNode = AddNode(color: .systemGreen)
            canvas.addSubview(newNode)
            NSLayoutConstraint.activate([
                newNode.leadingAnchor.constraint(equalTo: nodeTree[nodeTree.count - 1].trailingAnchor, constant: 30),
                newNode.bottomAnchor.constraint(equalTo: nodeTree[nodeTree.count - 1].topAnchor, constant: 0),
            ])
        } else {
            newNode = AddNode(color: .systemPink)
            canvas.addSubview(newNode)
            NSLayoutConstraint.activate([
                newNode.leadingAnchor.constraint(equalTo: nodeTree[nodeTree.count - 1].trailingAnchor, constant: 30),
                newNode.topAnchor.constraint(equalTo: nodeTree[nodeTree.count - 1].bottomAnchor, constant: 0),
            ])
        }
        
        NSLayoutConstraint.activate([
            newNode.heightAnchor.constraint(equalToConstant: 60),
            newNode.widthAnchor.constraint(equalToConstant: 150),
        ])
        
        
        undoButton.isEnabled = true
        canvasHeightConstraint.constant += 90
        canvasWidthConstraint.constant += 180
        nodeTree.append(newNode)
        print(nodeTree.count)
    }
    
    @IBAction func didPressUndo(_ sender: UIButton) {
        if nodeTree.count > 1 {
            let removedNode = nodeTree.removeLast()
            removedNode.removeFromSuperview()
            print(nodeTree.count)
            canvasHeightConstraint.constant -= 90
            canvasWidthConstraint.constant -= 180
            undoButton.isEnabled = nodeTree.count > 1
            undoneNodeTree.append(removedNode)
            redoButton.isEnabled = true
        }
    }
    
    @IBAction func didPressRedo(_ sender: UIButton) {
        if !undoneNodeTree.isEmpty {
            let recoveredNode = undoneNodeTree.removeFirst()
            nodeTree.append(recoveredNode)
            canvas.addSubview(recoveredNode)
            redoButton.isEnabled = !undoneNodeTree.isEmpty
        }
    }
}

