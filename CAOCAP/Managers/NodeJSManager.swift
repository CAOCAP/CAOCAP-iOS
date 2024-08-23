//
//  NodeJSManager.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 19/08/2024.
//  https://nodejs-mobile.github.io/docs/guide/guide-ios/getting-started

import Foundation
import NodeMobile

/// Singleton class to manage Node.js engine within the app
class NodeJSManager {
    
    /// Shared instance for global access
    static let shared = NodeJSManager()
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    /// Starts Node.js with specified arguments
    /// - Parameter arguments: An array of strings representing Node.js arguments
    private func startNodeJS(withArguments arguments: [String]) {
        // Compute the total size needed for arguments in contiguous memory
        let cArgumentsSize = arguments.reduce(0) { $0 + $1.utf8.count + 1 }
        
        // Allocate memory for arguments
        let argsBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: cArgumentsSize)
        var argv: [UnsafeMutablePointer<CChar>?] = []
        
        var currentArgsPosition = argsBuffer
        for arg in arguments {
            strcpy(currentArgsPosition, arg)
            argv.append(currentArgsPosition)
            currentArgsPosition += arg.utf8.count + 1
        }
        
        argv.append(nil)
        
        // Start Node.js engine with arguments
        node_start(Int32(arguments.count), &argv)
        
        // Free allocated memory to prevent memory leaks
        argsBuffer.deallocate()
    }
    
    /// Starts a simple Node.js HTTP server on a background thread
    func startNodeServerInBackground() {
        guard let transpilePath = Bundle.main.path(forResource: "main", ofType: "js", inDirectory: "NodeScripts") else {
            print("Error: Could not find main.js file.")
            return
        }
        
        do {
            let mainJSCode = try String(contentsOfFile: transpilePath)
            
            let nodeArguments = ["node", "-e", mainJSCode]
            
            // Run Node.js server in a background thread to keep the UI responsive
            let nodejsThread = Thread {
                self.startNodeJS(withArguments: nodeArguments)
            }
            
            // Set stack size for Node.js thread
            nodejsThread.stackSize = 2 * 1024 * 1024  // 2MB of stack space
            
            // Start the thread
            nodejsThread.start()
        } catch {
            print("Error: Could not load JavaScript files: \(error)")
        }
        
    }
}
