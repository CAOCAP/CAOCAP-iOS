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
    var undos = [String]()
    var redos = [String]()
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
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
        
    }
    
    init(document: Document, undos: [String] = [], redos: [String] = [], selectedElementID: String? = nil) {
        self.document = document
        self.undos = undos
        self.redos = redos
        self.selectedElementID = selectedElementID
    }
    
    func getOuterHtml() -> String? {
        do {
            return try document?.outerHtml()
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
        return nil
    }
    
    
    func saveToUndos() {
        if let currentDoc = getOuterHtml() {
            undos.append(currentDoc)
        }
    }
    
    func undo() {
        if let currentDoc = getOuterHtml() {
            redos.append(currentDoc)
            do {
                document = try SwiftSoup.parse(undos.removeLast())
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                print("error")
            }
        }
    }
    
    func redo() {
        if let currentDoc = getOuterHtml() {
            undos.append(currentDoc)
            do {
                document = try SwiftSoup.parse(redos.removeLast())
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                print("error")
            }
        }
    }
    
    func getSelectedElement() -> Element? {
        if let selectedElementID = selectedElementID {
            do {
                return try document?.body()?.getElementById(selectedElementID)
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                print("error")
            }
        }
        return nil
    }
    
    func getSelectedElementType() -> String? {
        do {
            return try getSelectedElement()?.attr("type")
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
        return nil
    }
    
    func updateSelectedElementText(content: String) {
        do {
            try getSelectedElement()?.text(content)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }
    
    func isSelectedElementHidden() -> Bool {
         return getSelectedElement()?.hasAttr("hidden") ?? false
    }
    
    func setSelectedElementHidden(_ isHidden: Bool) {
        do {
            if isHidden {
                try getSelectedElement()?.attr("hidden", "")
            } else {
                try getSelectedElement()?.removeAttr("hidden")
            }
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }
    
    func setSelectedElementBackground(color: String) {
        // TODO: find out how to set the background color
    }
    
    func getSelectedElementBackgroundColor() -> String {
        // TODO: find out how to get the background color
        return ""
    }
}
