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
        canvas.addSubview(node)
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
            
            node.centerXAnchor.constraint(equalTo: canvas.centerXAnchor),
            node.centerYAnchor.constraint(equalTo: canvas.centerYAnchor),
            node.heightAnchor.constraint(equalToConstant: 100),
            node.widthAnchor.constraint(equalToConstant: 200)
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
        view.backgroundColor = .secondarySystemFill
        return view
    }()
    
    let node: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemBlue
        return view
    }()
    
    
}

