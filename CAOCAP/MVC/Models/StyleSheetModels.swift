//
//  StyleSheetModels.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 08/02/2025.
//

import Foundation

class Styles {
    static let shared = Styles()
    let selectors: [Selector] = []
}

class Selector {
    var properties: [Property] = []
}

class Property {
    var id: String
    var value: String
    
    init(id: String, value: String) {
        self.id = id
        self.value = value
    }
}

