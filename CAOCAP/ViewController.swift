//
//  ViewController.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 03/06/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var nodeTree = NodeTree()
    var nodeTreeHistory = [NodeTree]()
    
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    var canvasHeightConstraint = NSLayoutConstraint()
    var canvasWidthConstraint = NSLayoutConstraint()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 0.3
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
        return scrollView
    }()
    
    let canvas: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(patternImage: UIImage(named: "dot")!)
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
        scrollView.delegate = self
        
        canvasHeightConstraint = canvas.heightAnchor.constraint(equalToConstant: view.frame.height + 200)
        canvasWidthConstraint = canvas.widthAnchor.constraint(equalToConstant: view.frame.width + 200 )
        canvasHeightConstraint.isActive = true
        canvasWidthConstraint.isActive = true
        
        loadMindMap()
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            canvas.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: scrollView.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        //Load HTML
        webview.loadHTMLString("<h1>Hello CAOCAP</h1>", baseURL: nil)
    }
    
    
    func loadMindMap() {
        let startingNode = createNodeView(from: nodeTree.root)
        canvas.addSubview(startingNode)
        NSLayoutConstraint.activate([
            startingNode.heightAnchor.constraint(equalToConstant: 60),
            startingNode.widthAnchor.constraint(equalToConstant: 150),
            startingNode.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: canvasWidthConstraint.constant / 2 - 75),
            startingNode.centerYAnchor.constraint(equalTo: canvas.centerYAnchor),
        ])
    }
    
    func updateMindMap() {
        var node = nodeTree.root
        while true {
            let nodeView = createNodeView(from: node)
            canvas.addSubview(nodeView)
            NSLayoutConstraint.activate([
                nodeView.heightAnchor.constraint(equalToConstant: 60),
                nodeView.widthAnchor.constraint(equalToConstant: 150),
    //            nodeView.leadingAnchor.constraint(equalTo: .trailingAnchor, constant: 30),
    //            nodeView.topAnchor.constraint(equalTo: .bottomAnchor, constant: 0),
            ])
            canvasHeightConstraint.constant += 60
            canvasWidthConstraint.constant += 180
            node = node.children[0]
            break
        }
    }
    
    func createNodeView(from node: Node) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = node.color
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 60))
        label.textAlignment = .center
        label.text = node.title
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        view.addSubview(label)
        return view
    }
    
    @IBAction func didPressAddNode(_ sender: UIButton) {
        nodeTreeHistory.removeAll()
        redoButton.isEnabled = false
        undoButton.isEnabled = true
        let node = sender.tag == 0 ? Node(title: "Head", color: .systemGreen) : Node(title: "Body", color: .systemPink)
        nodeTree.root.add(child: node)
        print(nodeTree.root.children.count)
        updateMindMap()
    }
    
    @IBAction func didPressUndo(_ sender: UIButton) {
        if nodeTree.root.children.count > 1 {
            nodeTree.root.removeLastNode()
            print(nodeTree.root.children.count)
            undoButton.isEnabled = nodeTree.root.children.count > 1
            redoButton.isEnabled = true
            nodeTreeHistory.append(nodeTree)
            updateMindMap()
        }
    }
    
    @IBAction func didPressRedo(_ sender: UIButton) {
        if !nodeTreeHistory.isEmpty {
            let recoveredNodeTree = nodeTreeHistory.removeFirst()
            nodeTree = recoveredNodeTree
            redoButton.isEnabled = !nodeTreeHistory.isEmpty
            updateMindMap()
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvas
    }
}
