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

func reduxReducer(action: Action, state: ReduxState?) -> ReduxState {
    var state = state ?? ReduxState()

    switch action {
    case _ as SomeFakeAction:
        print("this is just a demo")
    case _ as SomeFakeAction2:
        print("this is just a demo2")
    default:
        break
    }

    return state
}
