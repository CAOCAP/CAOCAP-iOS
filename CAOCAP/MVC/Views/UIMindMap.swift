//
//  UIMindMap.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 07/06/2023.
//

import UIKit
import SwiftSoup

protocol UIMindMapDelegate {
    func didRemoveNode()
}

class UIMindMap: UIScrollView, UIScrollViewDelegate {
    
    var body: Element
    var bodyHistory: [Element]
    var selectedID: String
    var nodeTree = [String: UINodeView]()
    
    var mindMapDelegate: UIMindMapDelegate?
    var canvasHeightConstraint = NSLayoutConstraint()
    var canvasWidthConstraint = NSLayoutConstraint()
    
    let canvas: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(patternImage: UIImage(named: "dot")!)
        return view
    }()
    
    init(frame: CGRect, body: Element, history: [Element] = [Element]()) {
        self.body = body
        bodyHistory = history
        selectedID = body.id()
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
        load(body: body)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(body: Element?) {
        print("\(#function)ing...")
        guard let body = body else { return }
        canvas.subviews.forEach({ $0.removeFromSuperview() })
        draw(body)
        if !body.children().isEmpty() { load(children: body.children()) }
        
    }
    
    func load(children: Elements) {
        print("\(#function)ing...")
        children.forEach { child in
            draw(child)
            if !child.children().isEmpty() { load(children: child.children()) }
        }
        
    }
    
    func add(_ element: Element) {
        print("\(#function)ing...")
        do {
            let selectedNode = try body.getElementById(selectedID)
            try selectedNode?.appendChild(element)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
        load(body: body)/*🤔 🤔 🤔*/
        select(element)
    }
    
    func delete(_ element: Element) {
        print("\(#function)ing...")
        guard let parent = element.parent() else { return }
        do {
            try parent.removeChild(element)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
        load(body: body)/*🤔 🤔 🤔*/
        select(parent)
    }
    
    func draw(_ element: Element) {
        print("\(#function)ing... \(element.tagName())")
        let nodeView = UINodeView(id: element.id(), title: element.tagName(), color: .systemBlue)
        nodeTree[element.id()] = nodeView
        nodeView.delegate = self
        canvas.addSubview(nodeView)
        
        if element.tagName() == "body" {
            nodeView.centerXAnchor.constraint(equalTo: canvas.centerXAnchor).isActive = true
            nodeView.centerYAnchor.constraint(equalTo: canvas.centerYAnchor).isActive = true
        } else {
            guard let parent = element.parent(), let parentView = nodeTree[parent.id()] else { return }
            do {
                let elementSiblingIndex = try element.elementSiblingIndex()
                //set nodeView constraints
                let centerPosition = Int(parent.children().count/2)
                if parent.children().count % 2 == 0 {
                    // even number of children ( two near centre children )
                    if elementSiblingIndex == centerPosition {
                        //near centre right child
                        nodeView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 90).isActive = true
                    } else if elementSiblingIndex == centerPosition - 1 {
                        //near centre left child
                        nodeView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: -90).isActive = true
                    } else {
                        //push to the right or left| i am 0 of 4 -> 0 - 2 + 0.5 -> -1.5*180, i am 3 of 4 -> 3 - 2 + 0.5 -> 1.5*180
                        let multiplier = Double(element.siblingIndex - centerPosition) + 0.5
                        nodeView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: CGFloat(multiplier * 180)).isActive = true
                    }
                } else {
                    // odd number of children ( one centered child )
                    if elementSiblingIndex == centerPosition {
                        //centered child
                        nodeView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
                    } else {
                        //push to the right or left
                        let multiplier = elementSiblingIndex - centerPosition
                        nodeView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: CGFloat(multiplier * 180)).isActive = true
                    }
                }
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                print("error")
            }
            nodeView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 120).isActive = true
        }
        
        if !element.children().isEmpty() {
            let nodeStroke = UIStroke(lines: element.children().count)
            canvas.insertSubview(nodeStroke, at: 0)
            nodeStroke.widthConstraint.constant = CGFloat(element.children().count * 180)
            nodeStroke.centerXAnchor.constraint(equalTo: nodeView.centerXAnchor).isActive = true
            nodeStroke.topAnchor.constraint(equalTo: nodeView.bottomAnchor).isActive = true
        }
        
        canvasWidthConstraint.constant += 30
        canvasHeightConstraint.constant += 30
    }
    
    func select(_ element: Element) {
        print("Previously Selected Node ID: \(selectedID)")
        let previouslySelectedID = selectedID
        selectedID = element.id()
        print("Current Selected Node ID: \(selectedID)")
        
        if let selectedNodeView = nodeTree[selectedID] {
            selectedNodeView.layer.borderWidth = 2
        }
        if let previousNodeView = nodeTree[previouslySelectedID] {
            previousNodeView.layer.borderWidth = 0
        }
    }
    
    func updateSelectedNode(_ direction: Direction?) {
        guard let direction = direction else { return }
        print("Previously Selected Node ID: \(selectedID)")
        let previouslySelectedID = selectedID
        //        switch direction {
        //        case .left:
        //            guard let selected = nodeTree.body.search(id: selectedID),
        //                  let parent = selected.parent,
        //                  selected.position > 0
        //            else { return }
        //            print("select prevues sibling")
        //            selectedID = parent.children[selected.position-1].id
        //        case .up:
        //            guard let selected = nodeTree.body.search(id: selectedID),
        //                  let parent = selected.parent
        //            else { return }
        //            print("select parent")
        //            selectedID = parent.id
        //        case .down:
        //            guard let firstChild = nodeTree.body.search(id: selectedID)?.children.first
        //            else { return }
        //            print("select first child")
        //            nodeTree.selectedID = firstChild.id
        //        case .right:
        //            guard let selected = nodeTree.body.search(id: selectedID),
        //                  let parent = selected.parent,
        //                  parent.children.count > selected.position + 1
        //            else { return }
        //            print("select next sibling")
        //            nodeTree.selectedID = parent.children[selected.position + 1].id
        //        }
        //
        //        print("Current Selected Node ID: \(selectedID)")
        //        guard let previousNodeView = nodeTree.body.search(id: previouslySelectedID)?.view,
        //              let currentNodeView = nodeTree.body.search(id: nodeTree.selectedID)?.view else { return }
        //        currentNodeView.layer.borderWidth = 2
        //        previousNodeView.layer.borderWidth = 0
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
    func select(nodeID: String) {
        print("\(#function)ing...")
        do {
            if let element = try body.getElementById(nodeID) {
                select(element)
            }
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }
    
    func delete(nodeID: String) {
        print("\(#function)ing...")
        do {
            if let element = try body.getElementById(nodeID) {
                DispatchQueue.main.async {
                    self.delete(element)
                    self.mindMapDelegate?.didRemoveNode()
                }
            }
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }
    
}
