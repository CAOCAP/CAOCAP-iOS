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
    
    var openedProject: Project?
    var projects: [Project]?
}
