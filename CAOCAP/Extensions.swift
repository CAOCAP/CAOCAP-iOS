//
//  Extensions.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 07/06/2023.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
