//
//  ReduxReducer.swift
//  taken from AtomiCube
//
//  Created by Azzam AL-Rashed on 25/08/2022.
//
/*
 
 Reducers provide pure functions,
 that based on the current action and the current app state,
 create a new app state.
 
 In order to have a predictable app state,
 it is important that the reducer is always free of side effects,
 it receives the current app state and an action and returns the new app state.
 
*/

import ReSwift
import SwiftSoup

func reduxReducer(action: Action, state: ReduxState?) -> ReduxState {
    var state = state ?? ReduxState()

    switch action { // this is not the best way, please fix this (https://reswift.github.io/ReSwift/master/getting-started-guide.html)
    case _ as CreateProjectAction,
         _ as OpenProjectAction,
         _ as CloseProjectAction,
         _ as UpdateSelectedElementAction,
         _ as EditProjectAction,
         _ as DeleteProjectAction:
        state = projectReducer(action: action, state: state)
    default:
        break
    }

    return state
}



func projectReducer(action: Action, state: ReduxState?) -> ReduxState {
    var state = state ?? ReduxState()

    switch action {
    case let action as CreateProjectAction:
        state.openedProject = action.newProject
        print("this is just a demo: did create new project")
    case _ as OpenProjectAction:
        print("this is just a demo: did open project")
    case _ as CloseProjectAction:
        print("this is just a demo: did close project")
    case let action as UpdateSelectedElementAction:
        state.openedProject?.selectedElementID = action.selectedID
        print("this is just a demo: did update selected element on opened project")
    case let action as EditProjectAction:
        state.openedProject?.document = action.updatedDoc
        print("this is just a demo: did edit the opened project")
    case _ as DeleteProjectAction:
        print("this is just a demo: did delete the opened project")
    default:
        break
    }

    return state
}
