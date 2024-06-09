//
//  UICanvas.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 01/01/2024.
//

import UIKit

class UICanvas: UIScrollView, UIScrollViewDelegate {
    
    var canvasHeightConstraint = NSLayoutConstraint()
    var canvasWidthConstraint = NSLayoutConstraint()
    
    let canvas: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(patternImage: UIImage(named: "dot")!)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        minimumZoomScale = 0.3
        maximumZoomScale = 3.0
        zoomScale = 0.5
        setupCanvas()
        contentInset = UIEdgeInsets(top: 200, left: 100, bottom: 200 , right: 100)
        contentOffset = CGPoint(x: -50, y: -150)
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCanvas() {
        addSubview(canvas)
        canvas.addGestureRecognizer(doubleTapZoom)
        canvas.isUserInteractionEnabled = true
        canvasHeightConstraint = canvas.heightAnchor.constraint(equalToConstant: frame.height + 200)
        canvasWidthConstraint = canvas.widthAnchor.constraint(equalToConstant: frame.width + 200 )
        canvasHeightConstraint.isActive = true
        canvasWidthConstraint.isActive = true
        canvas.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func expandCanvasIfNeeded() {
        canvas.layoutIfNeeded()
        canvas.subviews.forEach { view in
            if view.frame.maxY > canvasHeightConstraint.constant{
                canvasHeightConstraint.constant += 50
            }
            
            if view.frame.maxX > canvasWidthConstraint.constant || view.frame.minX < 0 {
                canvasWidthConstraint.constant += 50
            }
        }
    }
    
    func clearCanvas() {
        // this clears the canvas befor updating it with the new content
        canvas.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func centerCanvas() {
        print("\(#function)ing...")
        let centerPoint = CGPoint(x: canvasWidthConstraint.constant / 4,
                                  y: canvasHeightConstraint.constant / 4)
        zoom(toPoint: centerPoint, scale: 0.5, animated: true)
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
        /* centerCanvas() 🤔 🤔 🤔*/
    }

}
