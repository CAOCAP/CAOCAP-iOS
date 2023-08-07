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
    var commitHistory: [String]? //TODO: Create a model for Commits
    var dailyChallenges =  ["challenge 1"] //TODO: Create a model for Challenges
    var completeChallenges: [String]? //TODO: Create a model for Challenges
    
    var openedProject: Project?
    var projects: [Project]?
}
