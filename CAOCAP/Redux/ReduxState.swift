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
    var commitHistory: [String]?
    
    var openedProject: Project?
    var projects: [Project]?
}
