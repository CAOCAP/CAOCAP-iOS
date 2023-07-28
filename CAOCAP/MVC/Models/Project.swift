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
            <html lang="ar">
                <head>
                    <title>untitled</title>
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
    
    func getDocumentLang() -> String? {
        do {
            return try document?.getElementsByTag("html").attr("lang")
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
        return nil
    }
    
    func setDocumentLang(_ code: String) {
        do {
            try document?.getElementsByTag("html").attr("lang", code)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }
    
    func getDocumentTitle() -> String? {
        do {
            return try document?.head()?.getElementsByTag("title").first()?.text()
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
        return nil
    }
    
    func setDocumentTitle(_ title: String) {
        do {
            try document?.head()?.getElementsByTag("title").first()?.text(title)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
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
    
    func setSelectedElementText(content: String) {
        do {
            try getSelectedElement()?.text(content)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }
    
    func getSelectedElementTextAlignment() -> String? {
        guard let element = getSelectedElement() else { return nil }
        for textAlign in TailwindCSS.textAlign {
            if element.hasClass(textAlign) {
                return textAlign
            }
        }
        return nil
    }
    
    func setSelectedElementText(alignment: String) {
        guard let element = getSelectedElement() else { return }
        do {
            if let previousAlignment = getSelectedElementTextAlignment() {
                try element.removeClass(previousAlignment)
            }
            
            try element.addClass(alignment)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
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
    
    func setSelectedElement(type: String) {
        //TODO: setSelectedElement
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
    
    func getSelectedElementBackgroundColor() -> String {
        // TODO: find out how to get the background color
        return ""
    }
    
    func setSelectedElementBackground(color: String) {
        // TODO: find out how to set the background color
    }
}
