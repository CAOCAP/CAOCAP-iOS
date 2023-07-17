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
        do {
            selectedElementID = UUID().uuidString
            let html = #"""
            <!DOCTYPE html>
            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <script src="https://cdn.tailwindcss.com"></script>
                </head>
                <body id="\#(selectedElementID!)"></body>
            </html>
            """#
            document = try SwiftSoup.parse(html)
            if let document = document {
                documentHistory?.append(document)
            }
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
        
    }
    
    init(document: Document, documentHistory: [Document]? = nil, selectedElementID: String? = nil) {
        self.document = document
        self.documentHistory = documentHistory
        self.selectedElementID = selectedElementID
    }
}
