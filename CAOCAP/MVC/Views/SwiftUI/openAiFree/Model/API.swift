//
//  API.swift
//  CAOCAP
//
//  Created by khuloud alshammari on 21/02/1446 AH.
//



import Foundation

enum API{
    private static var apiKey: String?
    private static let plist = "OpenAI-Info"
    private static let apiKEY = "Api_Key"

    static var `default`: String {
        if let apiKey = apiKey {
            // إذا كانت القيمة مخزنة بالفعل، قم بإرجاعها مباشرة
            return apiKey
        } else {
            // إذا لم تكن القيمة مخزنة، قم بقراءتها من الملف
            guard let path = Bundle.main.path(forResource: plist, ofType: "plist") else {
                fatalError("Couldn't find file '\(plist).plist'.")
            }
            
            guard let plistDict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
                fatalError("Failed to parse plist file.")
            }
            
            guard let apiKeyValue = plistDict[apiKEY] as? String else {
               fatalError("Couldn't find key '\(apiKEY)' in plist.")
            }
            
            // تخزين القيمة في ذاكرة التخزين المؤقت
            apiKey = apiKeyValue
            
            return apiKeyValue
        }
    }
}
