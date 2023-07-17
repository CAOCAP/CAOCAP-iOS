//
//  Project.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 17/07/2023.
//

import Foundation
import SwiftSoup

class Project {
    var document: Document?
    var documentHistory: [Document]?
    var selectedElementID: String?
    
    init() {
        document = Document("")
        documentHistory = []
    }
    
    init(document: Document, documentHistory: [Document]? = nil, selectedElementID: String? = nil) {
        self.document = document
        self.documentHistory = documentHistory
        self.selectedElementID = selectedElementID
    }
}
