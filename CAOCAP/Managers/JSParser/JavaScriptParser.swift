//
//  JavaScriptParser.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 26/12/2023.
//

import Foundation
import JavaScriptCore

final class JavaScriptParser {
    static let shared = JavaScriptParser()
    let context = JSContext()
    
    func evaluateJS(with code: String) {/*🟨JS 🤯 this is working!*/
        // Evaluate JavaScript code that generates the AST
        
        // Load Acorn's JavaScript source code
        if let acornPath = Bundle.main.path(forResource: "acorn", ofType: "js") {
            if let acornScript = try? String(contentsOfFile: acornPath) {
                context?.evaluateScript(acornScript)
            }
        }
        
        // JavaScript code to generate the AST
        let stringifyJS = "JSON.stringify(acorn.parse('\(code)'))"
        
        // Evaluating JavaScript code
        let astString = context?.evaluateScript(stringifyJS)
        
        if let astData = astString?.toString().data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: astData, options: []) {
            if let astDictionary = json as? [String: Any] {
                print("AST: \(astDictionary)")
            }
        }
    }
    
}


