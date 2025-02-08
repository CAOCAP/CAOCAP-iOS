//
//  FlowChartModels.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 08/02/2025.
//

import Foundation

class Program {
    static let shared = Program()
    var events: [Event] = []
    
}

class Event {
    let id = UUID()
}

class Trigger {
    let id = UUID()
}

class Process {
    let id = UUID()
}

class Value {
    let id = UUID()
}
