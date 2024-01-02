//
//  UIMindMap.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 07/06/2023.
//

import UIKit
import SnapKit
import SwiftSoup

protocol UIMindMapDelegate {
    func didRemoveNode()
}

class UIMindMap: UICanvas {
    
    var project: Project?
    var nodeTree = [String: UINodeView]()
    var mindMapDelegate: UIMindMapDelegate?
    
    func draw(_ element: Element) {
        print("\(#function)ing... \(element.tagName())")
        let nodeView = UINodeView(node: UINode(name: element.tagName(), id: element.id(), countChildren: element.childNodeSize(), element: element))
        nodeTree[element.id()] = nodeView
        nodeView.delegate = self
        canvas.addSubview(nodeView)
        expandCanvas(width: 30, height: 30) 
        /*👆🏼🤔 expanding with a constent number is not the best way for this*/
        setNodePosition(nodeView)
        drawNodeStrokes(nodeView)
    }
    
    func setNodePosition(_ nodeView: UINodeView) {
        guard let element = nodeView.node.element else { return }
        if element.tagName() == "body" {
            nodeView.snp.makeConstraints { $0.center.equalToSuperview() }
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
                        nodeView.snp.makeConstraints { $0.centerX.equalTo(parentView.snp.centerX).offset(90)}
                    } else if elementSiblingIndex == centerPosition - 1 {
                        //near centre left child
                        nodeView.snp.makeConstraints { $0.centerX.equalTo(parentView.snp.centerX).offset(-90)}
                    } else {
                        //push to the right or left| i am 0 of 4 -> 0 - 2 - 0.5 -> -2*180, i am 3 of 4 -> 3 - 2 - 0.5 -> 1*180
                        let multiplier = Double(element.siblingIndex - centerPosition) - 0.5
                        nodeView.snp.makeConstraints { $0.centerX.equalTo(parentView.snp.centerX).offset(180 * multiplier)}
                    }
                } else {
                    // odd number of children ( one centered child )
                    if elementSiblingIndex == centerPosition {
                        //centered child
                        nodeView.snp.makeConstraints { $0.centerX.equalTo(parentView.snp.centerX) }
                    } else {
                        //push to the right or left
                        let multiplier = elementSiblingIndex - centerPosition
                        nodeView.snp.makeConstraints { $0.centerX.equalTo(parentView.snp.centerX).offset(180 * multiplier) }
                    }
                }
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                print("error")
            }
            nodeView.snp.makeConstraints { $0.centerY.equalTo(parentView).offset(120)}
        }
    }
    
    func drawNodeStrokes(_ nodeView: UINodeView) {
        let countChildren = nodeView.node.countChildren
        if countChildren < 1 {
            let nodeStroke = UIStroke(lines: countChildren)
            canvas.insertSubview(nodeStroke, at: 0)
            nodeStroke.widthConstraint.constant = CGFloat(countChildren * 180)
            nodeStroke.snp.makeConstraints { make in
                make.centerX.equalTo(nodeView.snp.centerX)
                make.top.equalTo(nodeView.snp.bottom)
            }
        }
    }
    
    func loadBody() {
        print("\(#function)ing...")
        guard let body = project?.document?.body() else { return }
        clearCanvas()
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
    
    func add(tag: String) {
        print("\(#function)ing...")
        ReduxStore.dispatch(WillEditAction())
        guard let body = project?.document?.body(),
              let selectedID = project?.selectedElementID
        else { return }
        
        let newElement = Element(Tag(tag), "")
        do {
            try newElement.attr("id", UUID().uuidString)
            let selectedNode = try body.getElementById(selectedID)
            try selectedNode?.appendChild(newElement)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
        select(newElement.id())/*🤔*/
    }
    
    func delete(_ element: Element) {
        print("\(#function)ing...")
        ReduxStore.dispatch(WillEditAction())
        guard let parent = element.parent() else { return }
        do {
            try parent.removeChild(element)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
        select(parent.id())/*🤔*/
    }
    
    func select(_ elementID: String) {
        guard let previouslySelectedID = project?.selectedElementID else { return }
        print("Previously Selected Node ID: \(previouslySelectedID)")
        ReduxStore.dispatch(UpdateSelectedElementAction(selectedID: elementID))
        print("Current Selected Node ID: \(elementID)")
        if let selectedNodeView = nodeTree[elementID] {
            selectedNodeView.layer.borderWidth = 2
        }
        if let previousNodeView = nodeTree[previouslySelectedID] {
            previousNodeView.layer.borderWidth = 0
        }
    }
    
    func updateSelectedNode(_ direction: Direction?) {
        guard let direction = direction,
              let body = project?.document?.body(),
              let selectedID = project?.selectedElementID
        else { return }
        
        do {
            if let element = try body.getElementById(selectedID) {
                switch direction {
                case .left:
                    guard let previousSibling = try element.previousElementSibling() else { return }
                    print("select prevues sibling")
                    select(previousSibling.id())
                case .up:
                    guard let parent = element.parent() else { return }
                    print("select parent")
                    select(parent.id())
                case .down:
                    guard let firstChild = element.children().first() else { return }
                    print("select first child")
                    select(firstChild.id())
                case .right:
                    guard let nextSibling = try element.nextElementSibling() else { return }
                    print("select next sibling")
                    select(nextSibling.id())
                }
            }
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }
    
}


extension UIMindMap: UINodeViewDelegate {
    func select(nodeID: String) {
        print("\(#function)ing...")
        select(nodeID)
    }
    
    func delete(nodeID: String) {
        print("\(#function)ing...")
        guard let body = project?.document?.body() else { return }
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


