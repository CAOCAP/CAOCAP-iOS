//
//  StrokeView.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 21/06/2023.
//

import UIKit

class StrokeView: UIView {
    
    var parentView: NodeView?
    var childView: NodeView?
    var color = UIColor.label
    
    
    init(node: Node) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        childView = node.view
        parentView = node.parent?.view
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update() {
        if let parentView = parentView, let childView = childView {
            frame = parentView.frame.union(childView.frame)
            setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 2.5
        color.setStroke()
        if let parentView = parentView, let childView = childView {
            let parentCenter = CGPoint(x: parentView.center.x - frame.origin.x, y: parentView.center.y - frame.origin.y)
            let childCenter = CGPoint(x: childView.center.x - frame.origin.x, y: childView.center.y - frame.origin.y)

            path.move(to: parentCenter)
            
            let point1 = CGPoint(x: parentCenter.x + (childCenter.x - parentCenter.x) / 2, y: parentCenter.y)
            let point2 = CGPoint(x: childCenter.x - (childCenter.x - parentCenter.x) / 2, y: childCenter.y)
            
            path.addCurve(to: childCenter, controlPoint1: point1, controlPoint2: point2)
            path.stroke()
        }
    }
}
