//
//  FirebaseRepository.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 06/08/2023.
//

import Foundation
import Firebase


// MARK: - Firebase Repository

class FirebaseRepository {
    static let shared = FirebaseRepository()
    
    func configuration() {
        FirebaseApp.configure()
        anonymousAuth()
    }
    
    func anonymousAuth() {
        if let user = Auth.auth().currentUser {
            ReduxStore.dispatch(AuthUserAction(user: user))
        } else {
            Auth.auth().signInAnonymously { authResult, error in
                guard let user = authResult?.user else { return }
                ReduxStore.dispatch(AuthUserAction(user: user))
            }
        }
    }
}
