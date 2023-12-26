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
    
    init() {
        // Load Acorn+walk's JavaScript source code
        if let acornPath = Bundle.main.path(forResource: "acorn", ofType: "js"),
            let walkPath = Bundle.main.path(forResource: "walk", ofType: "js") {
            if let acornScript = try? String(contentsOfFile: acornPath),
                let walkScript = try? String(contentsOfFile: walkPath) {
                context?.evaluateScript(acornScript)
                context?.evaluateScript(walkScript)
            }
        }
    }
    
    func parseJS(code: String) -> [String: Any]? {/*🟨JS 🤯 this is working!*/
        
        // JavaScript code to generate the AST
        let stringifyJS = "JSON.stringify(acorn.parse('\(code)'))"
        
        // Evaluating JavaScript code
        let astString = context?.evaluateScript(stringifyJS)
        
        if let astData = astString?.toString().data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: astData, options: []) {
            if let astDictionary = json as? [String: Any] {
                return astDictionary
            }
        }
        return nil
    }
    
    func generateJSCode(from ast: [String: Any]) -> String? {/*🟨JS this is not❗️ working!*/
        
        // Generate JavaScript code using acorn-walk
        let generateCodeFunction = """
            let generatedCode = 'abc';
                acorn.walk.simple(acorn.parse("let x = 10"), {
                    Literal(node) {
                        generatedCode = node.value
                        console.log(`Found a literal: ${node.value}`)
                    }
                });
                generatedCode;
        """

        
        // Evaluating the code generation function within the context
        if let generatedCode = context?.evaluateScript(generateCodeFunction) {
            print("Generated JavaScript code: \(generatedCode.toString())")
            return "good"
        }
        return nil
    }
    
}


