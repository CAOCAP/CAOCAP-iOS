//
//  ReduxActions.swift
//  taken from AtomiCube
//
//  Created by Azzam AL-Rashed on 25/08/2022.
//
/*
 
 Actions are a declarative way of describing a state change.
 Actions don't contain any code, they are consumed by the store and forwarded to reducers.
 Reducers will handle the actions by implementing a different state change for each action.
 
*/


import ReSwift
import SwiftSoup

// MARK: Project Actions

struct CreateProjectAction: Action { let newProject: Project } 
struct DeleteProjectAction: Action {}

struct OpenProjectAction: Action {}
struct CloseProjectAction: Action {}

struct UpdateSelectedElementAction: Action { let selectedID: String }


// MARK: Undo/Redo Actions
struct WillEditAction: Action {}
struct UndoAction: Action {}
struct RedoAction: Action {}
