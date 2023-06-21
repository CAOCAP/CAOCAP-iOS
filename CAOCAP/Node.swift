//
//  Node.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 07/06/2023.
//

import UIKit

struct NodeTree {
    var selectedID: UUID
    var root = Node(title: "HTML", color: .systemBlue)
    
    init() { selectedID = root.id }
}

class Node: NSObject {
    
    let id = UUID()
    let title: String
    let element: String
    let textContent: String
    var position: Int {
        return parent?.children.firstIndex(of: self) ?? 0
    }
    
    weak var parent: Node?
    weak var previous: Node? /* 🤔 */
    weak var next: Node?
    private (set) var children: [Node] = []
    private (set) var view: NodeView
    private (set) var stroke = StrokeView()
    
    override var description: String {
        var text = title
        if !children.isEmpty {
            text += " [" + children.map { $0.description }.joined(separator: ", ") + "] "
        }
        return text
    }
    
    var dom: String {
        var result = ""
        if children.isEmpty {
            result += "<\(element)>\(textContent)</\(element)>"
        } else {
            result += "<\(element)>" + children.map { $0.dom }.joined(separator: "") + "</\(element)>"
        }
        return result
    }
    
    // MARK: Initialize
    init(title: String, color: UIColor, text: String = "" /* 🤔 */) {
        self.title = title
        element = title.lowercased()
        textContent = text
        view = NodeView(id: id, title: title, color: color)
    }
    
    // MARK: Methods
    func add(child: Node) {
        children.append(child)
        child.parent = self
        stroke = StrokeView(lines: children.count)
    }
    
    func search(id: UUID) -> Node? {
        if let n = self.children.filter({ $0.id == id}).first {
            return n
        }
        if id == self.id {
            return self
        }
        for child in children {
            if let found = child.search(id: id) {
                return found
            }
        }
        return nil
    }
    
    func removeLastNode() {
        children.removeLast()
    }
    
    func remove(node: Node) {
        guard let parent = node.parent else { return }
        parent.children.removeAll { $0 == node }
    }
    
    func removeNode(with id: UUID) {
        guard let node = search(id: id),
            let parent = node.parent else { return }
        parent.children.removeAll { $0 == node }
    }
    
    func depthOfNode() -> Int {
        var depth = 0
        if let parent = parent {
            depth = parent.depthOfNode() + 1
        }
        return depth
    }
    
    func depthOfNode(id: UUID) -> Int {
        var result = 0
        var node = search(id: id)
        
        while node?.parent != nil  {
            result += 2
            node = node?.parent
        }
        return result
    }
    
    func forEachDepthFirst(visit: (Node) -> Void) {
        visit(self)
        children.forEach { $0.forEachDepthFirst(visit: visit) }
    }
    
}
