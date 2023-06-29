//
//  UINodeView.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 21/06/2023.
//

import UIKit

protocol UINodeViewDelegate {
    func select(nodeID: UUID)
    func delete(nodeID: UUID)
}

class UINodeView: UIView, UIContextMenuInteractionDelegate {
    let nodeID: UUID
    var delegate: UINodeViewDelegate?
    init(id: UUID, title: String, color: UIColor) {
        nodeID = id
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        widthAnchor.constraint(equalToConstant: 150).isActive = true
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
