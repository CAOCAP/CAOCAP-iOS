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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.setContentOffset(CGPoint(x: 100, y: 100), animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup scrollview
        view.insertSubview(scrollView, at: 0)
        scrollView.addSubview(canvas)
        let firstNode = AddNode()
        let secondNode = AddNode(color: .systemGreen)
        let thirdNode = AddNode(color: .systemPink)
        canvas.addSubview(firstNode)
        canvas.addSubview(secondNode)
        canvas.addSubview(thirdNode)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            canvas.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: scrollView.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            canvas.heightAnchor.constraint(equalToConstant: view.frame.height + 200),
            canvas.widthAnchor.constraint(equalToConstant: view.frame.width + 200 ),
            
            firstNode.centerXAnchor.constraint(equalTo: canvas.centerXAnchor),
            firstNode.centerYAnchor.constraint(equalTo: canvas.centerYAnchor),
            firstNode.heightAnchor.constraint(equalToConstant: 100),
            firstNode.widthAnchor.constraint(equalToConstant: 200),
            
            secondNode.centerXAnchor.constraint(equalTo: canvas.centerXAnchor, constant: 250),
            secondNode.centerYAnchor.constraint(equalTo: canvas.centerYAnchor, constant: 100),
            secondNode.heightAnchor.constraint(equalToConstant: 100),
            secondNode.widthAnchor.constraint(equalToConstant: 200),
            
            thirdNode.centerXAnchor.constraint(equalTo: canvas.centerXAnchor, constant: 250),
            thirdNode.centerYAnchor.constraint(equalTo: canvas.centerYAnchor, constant: -100),
            thirdNode.heightAnchor.constraint(equalToConstant: 100),
            thirdNode.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        
        //Load HTML
        webview.loadHTMLString("<h1>Hello CAOCAP</h1>", baseURL: nil)
    }
    
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
    
    func AddNode(color: UIColor = .systemBlue) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = color
        return view
    }
    
    
}

