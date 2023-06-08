////
////  ScrollView.swift
////  CAOCAP
////
////  Created by Azzam AL-Rashed on 07/06/2023.
////
//
//import UIKit
//
//class ScrollView: UIScrollView, UIScrollViewDelegate {
//
//    init(viewHeight: CG) {
//        super.init(frame: .zero)
//        translatesAutoresizingMaskIntoConstraints = false
//        setContentOffset(CGPoint(x: 100, y: 100), animated: false)
//        minimumZoomScale = 0.3
//        maximumZoomScale = 3.0
//        zoomScale = 1.0
//
//        let canvas = UIView()
//        canvas.translatesAutoresizingMaskIntoConstraints = false
//        canvas.layer.cornerRadius = 10
//        canvas.backgroundColor = UIColor(patternImage: UIImage(named: "dot")!)
//
//        canvasHeightConstraint = canvas.heightAnchor.constraint(equalToConstant: view.frame.height + 200)
//        canvasWidthConstraint = canvas.widthAnchor.constraint(equalToConstant: view.frame.width + 200 )
//        canvasHeightConstraint.isActive = true
//        canvasWidthConstraint.isActive = true
//
//        addSubview(canvas)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return canvas
//    }
//}
