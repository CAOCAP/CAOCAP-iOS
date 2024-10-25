//
//  Challenge.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 08/08/2023.
//

import Foundation

class Challenge {
    let title: String
    let description: String
    let regex: Regex<AnyRegexOutput>
    var isComplete: Bool
    
    init(title: String, description: String, regex: Regex<AnyRegexOutput>, isComplete: Bool = false) {
        self.title = title
        self.description = description
        self.regex = regex
        self.isComplete = isComplete
    }
}
