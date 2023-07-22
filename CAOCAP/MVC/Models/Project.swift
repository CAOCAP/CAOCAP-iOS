//
//  Project.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 17/07/2023.
//

import Foundation
import SwiftSoup

struct ProjectState {
    var document: String
    var selectedElementID: String
}

class Project {
    
    var document: Document?
    var selectedElementID: String?
    var undos = [ProjectState]()
    var redos = [ProjectState]()
    
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
    
    init(document: Document, undos: [ProjectState] = [], redos: [ProjectState] = [], selectedElementID: String? = nil) {
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
    
    
    func saveToUndos() { //TODO: change function name
        if let currentDoc = getOuterHtml(),
            let id = selectedElementID {
            redos.removeAll()
            undos.append(ProjectState(document: currentDoc, selectedElementID: id))
        }
    }
    
    func undo() {
        guard !undos.isEmpty else { return }
        if let currentDoc = getOuterHtml(),
            let id = selectedElementID {
            redos.append(ProjectState(document: currentDoc, selectedElementID: id))
            do {
                let undone = undos.removeLast()
                document = try SwiftSoup.parse(undone.document)
                selectedElementID = undone.selectedElementID
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                print("error")
            }
        }
    }
    
    func redo() {
        guard !redos.isEmpty else { return }
        if let currentDoc = getOuterHtml(),
           let id = selectedElementID {
            undos.append(ProjectState(document: currentDoc, selectedElementID: id))
            do {
                let redone = redos.removeLast()
                document = try SwiftSoup.parse(redone.document)
                selectedElementID = redone.selectedElementID
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
