//
//  InitialVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 13/06/2023.
//

import UIKit

class InitialVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appVersion.text = getVersion()
    }
    
    @IBAction func didEndEditingUserName(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = "Anonymous User"
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func getVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String
        else { return "0.0.0 (0)" }
        return "\(version) (\(build))"
    }
    
}

