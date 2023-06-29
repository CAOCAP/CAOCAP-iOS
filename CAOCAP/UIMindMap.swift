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
        canvas.subviews.forEach({ $0.removeFromSuperview() })
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
        selectedNode.add(child: node)
        load(root: nodeTree.root)/*🤔 🤔 🤔*/
        select(node)
    }
    
    func delete(_ node: Node) {
        print("\(#function)ing...")
        guard let parent = node.parent else { return }
        parent.remove(node: node)
        load(root: nodeTree.root)/*🤔 🤔 🤔*/
        select(parent)
    }
    
    func draw(_ node: Node) {
        print("\(#function)ing... \(node.title)")
        canvas.addSubview(node.view)
        node.view.delegate = self
        
        if !node.children.isEmpty {
            canvas.insertSubview(node.stroke, at: 0)
            node.stroke.widthConstraint.constant = CGFloat(node.children.count * 180)
            node.stroke.centerXAnchor.constraint(equalTo: node.view.centerXAnchor).isActive = true
            node.stroke.topAnchor.constraint(equalTo: node.view.bottomAnchor).isActive = true
        }
        
        
        if let parent = node.parent {
            //set nodeView constraints
            let centerPosition = Int(parent.children.count/2)
            if parent.children.count % 2 == 0 {
                // even number of children ( two near centre children )
                if node.position == centerPosition {
                    //near centre right child
                    node.view.centerXAnchor.constraint(equalTo: parent.view.centerXAnchor, constant: 90).isActive = true
                } else if node.position == centerPosition - 1 {
                    //near centre left child
                    node.view.centerXAnchor.constraint(equalTo: parent.view.centerXAnchor, constant: -90).isActive = true
                } else {
                    //push to the right or left| i am 0 of 4 -> 0 - 2 + 0.5 -> -1.5*180, i am 3 of 4 -> 3 - 2 + 0.5 -> 1.5*180
                    let multiplier = Double(node.position - centerPosition) + 0.5
                    node.view.centerXAnchor.constraint(equalTo: parent.view.centerXAnchor, constant: CGFloat(multiplier * 180)).isActive = true
                }
            } else {
                // odd number of children ( one centered child )
                if node.position == centerPosition {
                    //centered child
                    node.view.centerXAnchor.constraint(equalTo: parent.view.centerXAnchor).isActive = true
                } else {
                    //push to the right or left
                    let multiplier = node.position - centerPosition
                    node.view.centerXAnchor.constraint(equalTo: parent.view.centerXAnchor, constant: CGFloat(multiplier * 180)).isActive = true
                }
            }
            node.view.centerYAnchor.constraint(equalTo: parent.view.centerYAnchor, constant: 120).isActive = true
        } else {
            node.view.centerXAnchor.constraint(equalTo: canvas.centerXAnchor).isActive = true
            node.view.centerYAnchor.constraint(equalTo: canvas.centerYAnchor).isActive = true
        }
        
        canvasWidthConstraint.constant += 30
        canvasHeightConstraint.constant += 30
    }
    
    func select(_ node: Node) {
        print("Previously Selected Node ID: \(nodeTree.selectedID)")
        let previouslySelectedID = nodeTree.selectedID
        nodeTree.selectedID = node.id
        let currentNodeView = node.view
        currentNodeView.layer.borderWidth = 2
        print("Current Selected Node ID: \(nodeTree.selectedID)")
        guard let previousNodeView = nodeTree.root.search(id: previouslySelectedID)?.view else { return }
        previousNodeView.layer.borderWidth = 0
        
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
        
        print("Current Selected Node ID: \(nodeTree.selectedID)")
        guard let previousNodeView = nodeTree.root.search(id: previouslySelectedID)?.view,
              let currentNodeView = nodeTree.root.search(id: nodeTree.selectedID)?.view else { return }
        currentNodeView.layer.borderWidth = 2
        previousNodeView.layer.borderWidth = 0
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


extension UIMindMap: UINodeViewDelegate {
    func select(nodeID: UUID) {
        guard let node = nodeTree.root.search(id: nodeID) else { return }
        select(node)
    }
    
    func delete(nodeID: UUID) {
        print("\(#function)ing...")
        guard let node = nodeTree.root.search(id: nodeID) else { return }
        DispatchQueue.main.async {
            self.delete(node)
        }
    }
    
}
