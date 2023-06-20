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
    var position = 0
    
    weak var parent: Node?
    weak var previous: Node? /* 🤔 */
    weak var next: Node?
    private (set) var children: [Node] = []
    private (set) var view: NodeView
    
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
        view = NodeView(id: self.id, title: title, color: color)
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

protocol NodeViewDelegate {
    func select(nodeID: UUID)
    func delete(nodeID: UUID)
}

class NodeView: UIView, UIContextMenuInteractionDelegate {
    let nodeID: UUID
    var delegate: NodeViewDelegate?
    init(id: UUID, title: String, color: UIColor) {
        nodeID = id
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderColor = UIColor.blue.cgColor
        backgroundColor = color
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 60))
        label.textAlignment = .center
        label.text = title
        label.textColor = .white
        label.font = UIFont.ubuntu(.medium, size: 20)
        addSubview(label)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:))))
        addInteraction(UIContextMenuInteraction(delegate: self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTap(gesture: UITapGestureRecognizer) {
        print("did tap node:\(nodeID)")
        delegate?.select(nodeID: nodeID)
    }
    
    func delete() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider:  { _ in
            return UIMenu(options: [.displayInline], children: [UIAction(title: "Remove", attributes: .destructive, handler: { _ in
                self.delegate?.delete(nodeID: self.nodeID)
            })])
        })
    }
    
    
    //MARK: - Stolen from https://kylebashour.com/posts/context-menu-guide
    // improved UI behaviour
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let visiblePath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16)
        let parameters = UIPreviewParameters()
        parameters.visiblePath = visiblePath
        parameters.backgroundColor = .clear
        return UITargetedPreview(view: self, parameters: parameters)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.makeTargetedPreview(for: configuration)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.makeTargetedPreview(for: configuration)
    }
}
