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
    let state = state ?? ReduxState(document: Document(""), documentHistory: [])

    switch action {
    case _ as SomeDocumentAction:
        print("this is just a demo: document did change")
    case _ as SomeDocumentHistoryAction:
        print("this is just a demo: document history did change")
    default:
        break
    }

    return state
}
