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
    // MARK: Stored properties
    let id = UUID()
    let title: String
    let element: String
    let textContent: String
    let color: UIColor
    var position = 0
    
    private (set) var children: [Node] = []
    weak var parent: Node?
    
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
        element = title.lowercased()
        textContent = text
        self.title = title
        self.color = color
    }
    
    // MARK: Methods
    func add(child: Node) {
        child.position = children.count
        children.append(child)
        child.parent = self
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
        if let nodeToDelete = search(id: node.id), let parentNodeToDelete = nodeToDelete.parent {
            parentNodeToDelete.children.removeAll(where: { childNode in
                nodeToDelete == childNode
            })
        }
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

class NodeView: UIView {
    var node: Node
    
    init(_ node: Node) {
        self.node = node
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderColor = UIColor.blue.cgColor
        backgroundColor = node.color
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 60))
        label.textAlignment = .center
        label.text = node.title
        label.textColor = .white
        label.font = UIFont.ubuntu(.medium, size: 20)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


