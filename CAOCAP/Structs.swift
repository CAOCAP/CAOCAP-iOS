//
//  Structs.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 07/06/2023.
//

import UIKit

struct Node {
    let id = UUID.init()
    let title: String
    let color: UIColor
    var children: [Node]
    
    init(title: String = "Start", color: UIColor = .systemBlue, children: [Node] = []) {
        self.title = title
        self.color = color
        self.children = children
    }
}

struct NodeTree {
    var root = Node()
    var selectedID: UUID
    
    init() { selectedID = root.id }
}
