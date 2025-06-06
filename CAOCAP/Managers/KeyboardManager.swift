//
//  KeyboardManager.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 06/09/2023.
//

import UIKit
import IQKeyboardManagerSwift

/// `KeyboardManager` is a singleton class that manages the configuration of the IQKeyboardManager library,
/// which provides enhanced keyboard handling for iOS applications. This manager simplifies the setup of
/// IQKeyboardManager by centralizing its configuration.
final class KeyboardManager {
    
    /// The shared singleton instance of `KeyboardManager`, allowing centralized configuration of the keyboard settings.
    static let shared = KeyboardManager()
    
    // Private initializer to prevent instantiation from outside
    private init() {
        configureKeyboardManager()
    }
    
    /// Configures the IQKeyboardManager settings for the application.
    ///
    /// - The keyboard is enabled globally within the app.
    /// - The automatic toolbar provided by IQKeyboardManager is disabled.
    /// - The keyboard will automatically dismiss when the user taps outside of the text field.
    private func configureKeyboardManager() {
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.enable = true
        keyboardManager.enableAutoToolbar = false
        keyboardManager.shouldResignOnTouchOutside = true
    }
    
    /// A method that can be called to reapply the configuration if needed.
    /// This provides flexibility if you need to refresh or update the settings during runtime.
    func reconfigure() {
        configureKeyboardManager()
    }
}


extension UIViewController {
    
    //this dismiss Keyboard
    func hideKeyboardWhenTappedAround() {
        NotificationCenter.default.addObserver(self,selector: #selector(setKeyboardDistance),name: UIResponder.keyboardWillShowNotification,object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //this solves the keyboard distance from the TextField issue
    @objc func setKeyboardDistance(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if keyboardHeight > 300 {
                IQKeyboardManager.shared.keyboardDistanceFromTextField = 26
            } else {
                IQKeyboardManager.shared.keyboardDistanceFromTextField = 60
            }
        }
    }
}
