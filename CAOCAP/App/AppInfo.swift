//
//  AppInfo.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 27/05/2025.
//

import Foundation

struct AppInfo {
    static var version: String {
        let dictionary = Bundle.main.infoDictionary
        let version = dictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        let build = dictionary?["CFBundleVersion"] as? String ?? "0"
        return "\(version) (\(build))"
    }
}
