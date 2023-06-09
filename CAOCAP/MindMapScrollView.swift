//
//  MindMapScrollView.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 07/06/2023.
//

import UIKit

class MindMapScrollView: UIScrollView, UIScrollViewDelegate {
    
    var nodeTree: NodeTree
    var nodeTreeHistory: [NodeTree]
    var nodeViews = [NodeView]()

    var canvasHeightConstraint = NSLayoutConstraint()
    var canvasWidthConstraint = NSLayoutConstraint()
    
    let canvas: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(patternImage: UIImage(named: "dot")!)
        return view
    }()
    
    init(frame: CGRect, tree: NodeTree, history: [NodeTree] = [NodeTree]()) {
        nodeTree = tree
        nodeTreeHistory = history
        super.init(frame: .zero)
        delegate = self // ?🤔
        translatesAutoresizingMaskIntoConstraints = false
        minimumZoomScale = 0.5
        maximumZoomScale = 3.0
        zoomScale = 1.0
        addSubview(canvas)
        canvasHeightConstraint = canvas.heightAnchor.constraint(equalToConstant: frame.height + 200)
        canvasWidthConstraint = canvas.widthAnchor.constraint(equalToConstant: frame.width + 200 )
        canvasHeightConstraint.isActive = true
        canvasWidthConstraint.isActive = true
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: trailingAnchor),
            canvas.topAnchor.constraint(equalTo: topAnchor),
            canvas.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        contentInset = UIEdgeInsets(top: 200, left: 100, bottom: 200 , right: 100)
        contentOffset = CGPoint(x: 100, y: 100)
        layoutIfNeeded()
        canvas.addGestureRecognizer(doubleTapZoom)
        canvas.isUserInteractionEnabled = true
        load()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func load() {
        print("\(#function)ing...")
        let startingNode = draw(node: nodeTree.root)
        canvas.addSubview(startingNode)
        NSLayoutConstraint.activate([
            startingNode.heightAnchor.constraint(equalToConstant: 60),
            startingNode.widthAnchor.constraint(equalToConstant: 150),
            startingNode.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: canvasWidthConstraint.constant / 2 - 75),
            startingNode.centerYAnchor.constraint(equalTo: canvas.centerYAnchor),
        ])
    }
    
    func update() {
        print("\(#function)ing...")
        /*🤔 🤔 🤔*/
    }
    
    func draw(node: Node) -> NodeView {
        print("\(#function)ing...")
        let view = NodeView(node)
        /*🤔 🤔 🤔*/
        return view
    }
    
    func center() {
        print("\(#function)ing...")
        /*🤔 🤔 🤔*/
    }

    //MARK: - handle Zooming in/out
    lazy var doubleTapZoom: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()
    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(to: zoomRect(scale: zoomScale == minimumZoomScale ? maximumZoomScale : minimumZoomScale, center: location), animated: true)
    }
    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = canvasHeightConstraint.constant / scale
        zoomRect.size.width = canvasWidthConstraint.constant / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvas
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        /* center() 🤔 🤔 🤔*/
    }
}
