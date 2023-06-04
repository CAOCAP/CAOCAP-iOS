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
    @IBOutlet weak var webview: WKWebView!
    
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
        
        canvasHeightConstraint = canvas.heightAnchor.constraint(equalToConstant: view.frame.height + 200)
        canvasWidthConstraint = canvas.widthAnchor.constraint(equalToConstant: view.frame.width + 200 )
        canvasHeightConstraint.isActive = true
        canvasWidthConstraint.isActive = true
        
        
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
    
    @IBAction func didPressAdd(_ sender: Any) {
        let newNode = AddNode()
        nodeTree.append(newNode)
        canvas.addSubview(newNode)
        print(nodeTree.count)
        
        if nodeTree.count == 1 {
            NSLayoutConstraint.activate([
                newNode.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: canvasWidthConstraint.constant / 2),
                newNode.centerYAnchor.constraint(equalTo: canvas.centerYAnchor),
                newNode.heightAnchor.constraint(equalToConstant: 60),
                newNode.widthAnchor.constraint(equalToConstant: 150),
            ])
        } else {
            canvasHeightConstraint.constant += 90
            canvasWidthConstraint.constant += 180
            NSLayoutConstraint.activate([
                newNode.leadingAnchor.constraint(equalTo: nodeTree[nodeTree.count - 2].trailingAnchor, constant: 30),
                newNode.bottomAnchor.constraint(equalTo: nodeTree[nodeTree.count - 2].topAnchor, constant: 30),
                newNode.heightAnchor.constraint(equalToConstant: 60),
                newNode.widthAnchor.constraint(equalToConstant: 150),
            ])
        }
        
        
    }
}

