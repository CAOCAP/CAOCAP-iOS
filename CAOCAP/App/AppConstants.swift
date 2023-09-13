//
//  AppConstants.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 14/09/2023.
//

/*
 
 Why You Should Use a Constants File ?
 it is a methodology to help us writing clear, concise code
 
 What is a Constants file?
 A file dedicated to store declared constant properties.
 The beauty of this file is that it’s accessible globally throughout the app.
 
 Key benefits is having a central place for managing globally and repetitively used properties,
 the file is highly custom and you reduce the amount of mistakes such as typing in the wrong code.
 
 So what kind of properties can you store in the Constants file?
 ...

 
 learn more form this article:
 https://medium.com/swlh/why-you-should-use-a-constants-file-in-swift-ff8c40af1b39
*/

import Foundation

struct AppConstants {
    static let bodyID = "_body_"
    
    static let html = #"""
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>webview</title>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://unpkg.com/react@18/umd/react.development.js"></script>
        <script src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
        <script src="https://unpkg.com/redux@4.2.1/dist/redux.js"></script>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body id="\#(bodyID)"></body>
</html>
"""#
}
