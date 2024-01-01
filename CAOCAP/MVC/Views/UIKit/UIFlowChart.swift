//
//  UIFlowChart.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 01/01/2024.
//

import UIKit
import SnapKit
import SwiftSoup

protocol UIFlowChartDelegate {
    func didRemoveNode()
}

class UIFlowChart: UICanvas {
    
    var project: Project?
    var nodeTree = [String: UINodeView]()
    var flowChartDelegate: UIFlowChartDelegate?
    
    func draw(_ event: String) { /* TODO: Fix this flowChart function❗️🙃*/
        print("\(#function)ing... \(event)")
        let nodeView = UINodeView(element: Element(Tag(event), "")) /*❗️🙃*/
        nodeTree[event] = nodeView /*❗️🙃*/
        nodeView.delegate = self
        canvas.addSubview(nodeView)
        expandCanvas(width: 30, height: 30)
        /*👆🏼🤔 expanding with a constent number is not the best way for this*/
        setNodePosition(nodeView)
        drawNodeStrokes(nodeView)
    }
    
    func setNodePosition(_ nodeView: UINodeView) {
        /* TODO: Fix this flowChart function❗️🙃*/
        // TODO: set Node Position in FlowChart
        nodeView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    func drawNodeStrokes(_ nodeView: UINodeView) {
        let element = nodeView.element
        if !element.children().isEmpty() {
            let nodeStroke = UIStroke(lines: element.children().count)
            canvas.insertSubview(nodeStroke, at: 0)
            nodeStroke.widthConstraint.constant = CGFloat(element.children().count * 180)
            nodeStroke.snp.makeConstraints { make in
                make.centerX.equalTo(nodeView.snp.centerX)
                make.top.equalTo(nodeView.snp.bottom)
            }
        }
    }
    
    func loadStartEvent() { /*🟨JS: FlowChart should start with an "Event" node to be Event-driven programming */
        /* TODO: Fix this flowChart function❗️🙃*/
        print("\(#function)ing...")
        clearCanvas()
        draw("Start Event")
    }
    
    func add(tag: String) { /*🟨JS*/
        /* TODO: Fix this flowChart function❗️🙃*/
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
    
    func delete(_ element: Element) { /* TODO: Fix this flowChart function❗️🙃*/
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
    
    func updateSelectedNode(_ direction: Direction?) { /*🟨JS*/
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


extension UIFlowChart: UINodeViewDelegate {
    func select(nodeID: String) {
        print("\(#function)ing...")
        select(nodeID)
    }
    
    func delete(nodeID: String) { /* TODO: Fix this flowChart function❗️🙃*/
        print("\(#function)ing...")
        guard let body = project?.document?.body() else { return }
        do {
            if let element = try body.getElementById(nodeID) {
                DispatchQueue.main.async {
                    self.delete(element)
                    self.flowChartDelegate?.didRemoveNode()
                }
            }
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }
    
}



