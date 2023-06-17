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
        minimumZoomScale = 0.3
        maximumZoomScale = 3.0
        zoomScale = 0.5
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
        contentOffset = CGPoint(x: -50, y: -150)
        layoutIfNeeded()
        canvas.addGestureRecognizer(doubleTapZoom)
        canvas.isUserInteractionEnabled = true
        load(root: nodeTree.root)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(root: Node) {
        print("\(#function)ing...")
        draw(root)
        if !root.children.isEmpty { load(children: root.children) }
        
    }
    
    func load(children: [Node]) {
        print("\(#function)ing...")
        children.forEach { node in
            draw(node)
            if !node.children.isEmpty { load(children: node.children) }
        }
        
    }
    
    func add(_ node: Node) {
        print("\(#function)ing...")
        guard let selectedNode = nodeTree.root.search(id: nodeTree.selectedID) else { return }
        canvas.subviews.forEach({ $0.removeFromSuperview() })
        selectedNode.add(child: node)
        load(root: nodeTree.root)/*🤔 🤔 🤔*/
        selectedNew(node: node)
    }
    
    func draw(_ node: Node) {
        print("\(#function)ing... \(node.title)")
        let view = NodeView(node)
        canvas.addSubview(view)
        nodeViews.append(view)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 60),
            view.widthAnchor.constraint(equalToConstant: 150),
            view.centerXAnchor.constraint(equalTo: canvas.centerXAnchor,
                                          constant: CGFloat(180 * (node.position + (node.parent?.position ?? 0)))),
            /*🤔it's not working as expected 🤔*/
            view.centerYAnchor.constraint(equalTo: canvas.centerYAnchor,
                                          constant: CGFloat(100 * node.depthOfNode())),
        ])
        canvasWidthConstraint.constant += 20
        canvasHeightConstraint.constant += 20
    }
    
    func selectedNew(node: Node) {
        print("Previously Selected Node ID: \(nodeTree.selectedID)")
        let previouslySelectedID = nodeTree.selectedID
        print("select new child")
        nodeTree.selectedID = node.id
        guard let previousNodeView = nodeViews.first(where: { $0.node.id == previouslySelectedID }),
            let currentNodeView = nodeViews.first(where: { $0.node.id == nodeTree.selectedID })
        else { return }
        previousNodeView.layer.borderWidth = 0
        currentNodeView.layer.borderWidth = 2
        print("Current Selected Node ID: \(nodeTree.selectedID)")/*🤔*/
        
    }
    
    func updateSelectedNode(_ direction: Direction?) {
        guard let direction = direction else { return }
        print("Previously Selected Node ID: \(nodeTree.selectedID)")
        let previouslySelectedID = nodeTree.selectedID
        switch direction {
        case .left:
            guard let selected = nodeTree.root.search(id: nodeTree.selectedID),
                  let parent = selected.parent,
                  selected.position > 0
            else { return }
            print("select prevues sibling")
            nodeTree.selectedID = parent.children[selected.position-1].id
        case .up:
            guard let selected = nodeTree.root.search(id: nodeTree.selectedID),
                  let parent = selected.parent
            else { return }
            print("select parent")
            nodeTree.selectedID = parent.id
        case .down:
            guard let firstChild = nodeTree.root.search(id: nodeTree.selectedID)?.children.first
            else { return }
            print("select first child")
            nodeTree.selectedID = firstChild.id
        case .right:
            guard let selected = nodeTree.root.search(id: nodeTree.selectedID),
                  let parent = selected.parent,
                  parent.children.count > selected.position + 1
            else { return }
            print("select next sibling")
            nodeTree.selectedID = parent.children[selected.position + 1].id
        }
        guard
            let previousNodeView = nodeViews.first(where: { $0.node.id == previouslySelectedID }),
            let currentNodeView = nodeViews.first(where: { $0.node.id == nodeTree.selectedID })
        else { return }
        previousNodeView.layer.borderWidth = 0
        currentNodeView.layer.borderWidth = 2
        print("Current Selected Node ID: \(nodeTree.selectedID)")/*🤔*/
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
