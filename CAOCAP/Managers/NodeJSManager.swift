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
    
    /// This flag keeps track of whether the Node.js engine is already running.
    private var nodeIsRunning = false
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    /// Starts Node.js with specified arguments
    /// - Parameter arguments: An array of strings representing Node.js arguments
    private func startNodeJS(withArguments arguments: [String]) {
        // Compute the total size needed for arguments in contiguous memory
        let cArgumentsSize = arguments.reduce(0) { $0 + $1.utf8.count + 1 }
        
        // Allocate memory for the arguments buffer
        let argsBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: cArgumentsSize)
        
        // Ensure memory is deallocated after the function exits to prevent memory leaks
        defer {
            argsBuffer.deallocate()
        }
        
        // Array to store C-style pointers to argument strings
        var argv: [UnsafeMutablePointer<CChar>?] = []
        var currentArgsPosition = argsBuffer
        
        // Copy each argument string into the allocated memory buffer
        for arg in arguments {
            strcpy(currentArgsPosition, arg)  // Copy the argument string
            argv.append(currentArgsPosition)  // Store the pointer to the copied string
            currentArgsPosition += arg.utf8.count + 1  // Move to the next position in memory
        }
        
        // Null-terminate the arguments list as required by C functions
        argv.append(nil)
        
        // Start Node.js engine with arguments
        node_start(Int32(arguments.count), &argv)
    }
    
    /// Starts a simple Node.js HTTP server on a background thread
    func startNodeServerInBackground() {
        // Check if the Node.js engine is already running to prevent multiple starts
        guard !nodeIsRunning else {
            print("Node.js is already running.")
            return
        }
        
        // Find the path to the main JavaScript file in the app bundle
        guard let transpilePath = Bundle.main.path(forResource: "main", ofType: "js", inDirectory: "NodeScripts") else {
            print("Error: Could not find main.js file.")
            return
        }
        
        do {
            // Load the JavaScript code from the main.js file
            let mainJSCode = try String(contentsOfFile: transpilePath)
            
            // Define the arguments for the Node.js engine (using inline script execution)
            let nodeArguments = ["node", "-e", mainJSCode]
            
            // Run Node.js server in a background thread to keep the UI responsive
            let nodejsThread = Thread {
                self.startNodeJS(withArguments: nodeArguments)
            }
            
            // Set the stack size for the Node.js thread (increase if needed for larger scripts)
            nodejsThread.stackSize = 2 * 1024 * 1024  // 2MB of stack space
            
            // Start the thread
            nodejsThread.start()
            
            // Update the flag to indicate that the Node.js engine is running
            nodeIsRunning = true
            print("Node.js engine started.")
        } catch {
            print("Error: Could not load JavaScript files: \(error)")
        }
        
    }
}
