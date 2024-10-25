//
//  ReduxState.swift
//  taken from AtomiCube
//
//  Created by Azzam AL-Rashed on 25/08/2022.
//
/*
 
-
 
*/


import ReSwift

struct ReduxState {
    
    var user: User?
    var isSubscribed = false
    
    var commitHistory: [String]? //TODO: Create a model for Commits
    
    var dailyChallenges =  [
        Challenge(title: "Update Title",
                  description: "set a new website title",
                  regex:  .init(/<title>(?!webview<\/title>)(.*?)<\/title>/)),
        
        
        Challenge(title: "Change Background Color",
                  description: "change the website body background color",
                  regex:  .init(/<body[^>]*\bclass\s*=\s*["'][^"']*\bbg-[^\s"']+[^"']*["'][^>]*>/)),
        
        Challenge(title: "Add Image",
                  description: "add an image with a source URL",
                  regex:  .init(/<img(\s.*\s|\s)(src="http.+?")/)),
    ]
    var completeChallenges: [Challenge]?
    
    var openedProject: Project?
    var projects: [Project]?
}
