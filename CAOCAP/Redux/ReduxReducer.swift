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
 
 https://reswift.github.io/ReSwift/master/getting-started-guide.html
*/

import ReSwift
import SwiftSoup

func reduxReducer(action: Action, state: ReduxState?) -> ReduxState {
    var state = state ?? ReduxState()

    switch action {
    case let action as AuthUserAction:
        state.user = action.user
        FirebaseRepository.shared.commit(uid: action.user.uid, value: "BatMan!123")
    case let action as ReceivedCommitHistoryAction:
        state.commitHistory = action.commits
    case _ as CreateProjectAction,
         _ as OpenProjectAction,
         _ as CloseProjectAction,
         _ as UpdateSelectedElementAction,
         _ as DeleteProjectAction:
        state = projectReducer(action: action, state: state)
        
    case let action as UpdateProjectLangAction:
        state.openedProject?.saveToUndos()
        state.openedProject?.setDocumentLang(action.lang)
    case let action as UpdateProjectTitleAction:
        state.openedProject?.saveToUndos()
        state.openedProject?.setDocumentTitle(action.title)
    case let action as UpdateAction: // call this action before the document is edited to save last state
        state.openedProject?.saveToUndos()
        action.handler()
    case _ as WillEditAction:
        state.openedProject?.saveToUndos()
    case _ as UndoAction:
        state.openedProject?.undo()
    case _ as RedoAction:
        state.openedProject?.redo()
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
        state.openedProject = nil
        print("this is just a demo: did close project")
    case let action as UpdateSelectedElementAction:
        state.openedProject?.selectedElementID = action.selectedID
        print("this is just a demo: did update selected element on opened project")
    case _ as DeleteProjectAction:
        state.openedProject = nil
        print("this is just a demo: did delete the opened project")
    default:
        break
    }

    return state
}

