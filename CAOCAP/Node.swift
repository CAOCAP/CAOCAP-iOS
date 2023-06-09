//
//  Node.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 07/06/2023.
//

import UIKit

struct NodeTree {
    var root = Node(title: "Start", color: .systemBlue)
    var selectedID: UUID
    
    init() { selectedID = root.id }
}

class Node: NSObject {
    // MARK: Stored properties
    let id = UUID()
    var title: String
    var color: UIColor
    var centerPosition: CGPoint?
    
    private (set) var children: [Node] = []
    weak var parent: Node?
    
    override var description: String {
        var text = "\(title)"
        if !children.isEmpty {
            text += " [" + children.map { $0.description }.joined(separator: ", ") + "] "
        }
        return text
    }
    
    // MARK: Initialize
    init(title: String, color: UIColor) {
        self.title = title
        self.color = color
    }
    
    // MARK: Methods
    func add(child: Node) {
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
        backgroundColor = node.color
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 60))
        label.textAlignment = .center
        label.text = node.title
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


