//
//  UICanvasNodeView.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 21/06/2023.
//

import UIKit
import SwiftSoup

protocol UICanvasNodeViewDelegate {
    func select(nodeID: String)
    func delete(nodeID: String)
}

class CanvasNode {
    let name: String
    let id: String
    let parent: CanvasNode?
    let children: [CanvasNode]?
    let element: Element? /*🟨JS*/
    
    //this is used for UIMindMap
    init(element: Element) {
        self.name = element.tagName()
        self.id = element.id()
        self.parent = nil
        self.children = nil
        self.element = element
    }
    
    //this is used for UIFlowChart
    init(name: String, id: String, parent: CanvasNode? = nil, children: [CanvasNode] = []) {
        self.name = name
        self.id = id
        self.parent = parent
        self.children = children
        self.element = nil
    }
    
    
}

class UICanvasNodeView: UIView, UIContextMenuInteractionDelegate {
    let node: CanvasNode
    var delegate: UICanvasNodeViewDelegate?
    init(node: CanvasNode) {
        self.node = node
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true  //TODO: use SnapKit
        widthAnchor.constraint(equalToConstant: 150).isActive = true  //TODO: use SnapKit
        layer.cornerRadius = 10
        layer.borderColor = UIColor.purple.cgColor
        setBackgroundColor()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 60))
        label.textAlignment = .center
        label.text = node.name
        label.textColor = .white
        label.font = UIFont.ubuntu(.medium, size: 20)
        addSubview(label)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:))))
        addInteraction(UIContextMenuInteraction(delegate: self))
    }
    
    func setBackgroundColor() {
        switch node.name {
        case "body":
            backgroundColor = .systemBlue
        case "span","canvas","div","header","main","footer","article","section","aside","nav", "Start Event"/*❗️🙃*/:
            backgroundColor = .systemGreen
        case "button","a","input":
            backgroundColor = .systemPurple
        case "textArea","form","label","option","legend","select","fieldSet","optGroup","output":
            backgroundColor = .systemTeal
        case "video","img","audio":
            backgroundColor = .systemYellow
        case "li","h1","p":
            backgroundColor = .systemGray3
        case "ul","ol","br","hr":
            backgroundColor = .systemGray
        default:
            backgroundColor = .systemGray2
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTap(gesture: UITapGestureRecognizer) {
        print("did tap node:\(node.id)")
        delegate?.select(nodeID: node.id)
    }
    
    func delete() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider:  { _ in
            guard self.node.name != "body" else { return nil }
            return UIMenu(options: [.displayInline], children: [UIAction(title: "Remove", attributes: .destructive, handler: { _ in
                self.delegate?.delete(nodeID: self.node.id)
            })])
            
        })
    }
    
    
    //MARK: - Stolen from https://kylebashour.com/posts/context-menu-guide
    // improved UI behaviour
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let visiblePath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        let parameters = UIPreviewParameters()
        parameters.visiblePath = visiblePath
        parameters.backgroundColor = .clear
        return UITargetedPreview(view: self, parameters: parameters)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
}
