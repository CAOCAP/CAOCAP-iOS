//
//  InitialVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 13/06/2023.
//

import UIKit

class InitialVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appVersion.text = getVersion()
        setupStackView()
    }
    
    func setupStackView() {
        for stackIndex in 0...16 {
            let stack = UIStackView()
            for squareIndex in 0...6 {
                let square = UIView()
                let random = Int.random(in: 0...100)
                if random % 3 == 0 {
                    square.backgroundColor = .systemBlue
                } else {
                    square.backgroundColor = .systemGray2
                }
                square.cornerRadius = 2
                square.alpha = 0.75
                stack.addArrangedSubview(square)
            }
            stack.spacing = 3
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stackView.addArrangedSubview(stack)
        }
    }
    
    
    func getVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String
        else { return "0.0.0 (0)" }
        return "\(version) (\(build))"
    }
    
}

