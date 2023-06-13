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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didEndEditingUserName(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = "Anonymous User"
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }

}
