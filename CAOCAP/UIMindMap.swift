//
//  UIMindMap.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 07/06/2023.
//

import UIKit

class UIMindMap: UIScrollView, UIScrollViewDelegate {
    
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
        delegate = self
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
        load(root: nodeTree.root)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(_ node: Node) {
        print("\(#function)ing...")
        canvas.subviews.forEach({ $0.removeFromSuperview() })
        nodeTree.root.add(child: node)
        load(root: nodeTree.root)
    }
    
    
    func load(root: Node) {
        print("\(#function)ing...")
        draw(root)
        if !root.children.isEmpty { load(children: root.children) }
        
    }
    
    func load(children: [Node]) {
        print("\(#function)ing...")
        /*🤔 🤔 🤔*/
        children.forEach { node in
            draw(node)
            if !node.children.isEmpty { load(children: node.children) }
        }
        
    }
    
    func draw(_ node: Node) -> NodeView {
        print("\(#function)ing... \(node.title)")
        let view = NodeView(node)
        canvas.addSubview(view)
        nodeViews.append(view)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 60),
            view.widthAnchor.constraint(equalToConstant: 150),
            view.centerXAnchor.constraint(equalTo: canvas.centerXAnchor,
                                          constant: CGFloat(180 * node.position)),
            view.centerYAnchor.constraint(equalTo: canvas.centerYAnchor,
                                          constant: CGFloat(100 * node.depthOfNode())),
        ])
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
