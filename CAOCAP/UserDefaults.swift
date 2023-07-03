//
//  UserDefaults.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 03/07/2023.
//

import Foundation

extension UserDefaults {
    
    
    func didUserCompleteIntro() -> Bool {
        return bool(forKey: "introCompleted")
    }
    
    func introCompleted() {
        set(true, forKey: "introCompleted")
    }
    
}
