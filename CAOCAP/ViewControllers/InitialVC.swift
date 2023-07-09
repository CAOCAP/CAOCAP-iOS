//
//  InitialVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 13/06/2023.
//

import UIKit
import Firebase

class InitialVC: UIViewController, Storyboarded {
    var coordinator: MainCoordinator?

    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appVersion.text = getVersion()
        setupStackView()
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "id-testingFirebaseAnalytics",
          AnalyticsParameterItemName: "testingFirebaseAnalytics",
          AnalyticsParameterContentType: "cont",
        ])
    }
    
    func setupStackView() {
        var squares = [UIView]()
        let commitHistory = UserDefaults.standard.getCommitHistory()
        
        for _ in 0...16 {
            let stack = UIStackView()
            for _ in 0...6 {
                let square = UIView()
                square.alpha = 0.4
                square.backgroundColor = .systemGray5
                square.cornerRadius = 2
                squares.append(square)
                stack.addArrangedSubview(square)
            }
            stack.spacing = 3
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stackView.addArrangedSubview(stack)
        }
        squares.reverse()
        for commit in commitHistory {
            if let numberOfDays = Calendar.current.dateComponents([.day], from: commit, to: .now).day {
                if numberOfDays >= 0 && numberOfDays < squares.count {
                    let square = squares[numberOfDays]
                    square.backgroundColor = .label
                    if square.alpha < 1.0 {
                        square.alpha += 0.1
                    }
                }
            }
        }
    }
    
    
    func getVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String
        else { return "0.0.0 (0)" }
        return "\(version) (\(build))"
    }
    
    @IBAction func didPressSettingsButton(_ sender: Any) {
        coordinator?.viewMainSettings()
    }
    
    @IBAction func didPressProjectsButton(_ sender: Any) {
        coordinator?.viewProjects()
    }
    
    @IBAction func didPressPurchaseButton(_ sender: Any) {
        coordinator?.viewPurchase()
    }
    
    @IBAction func didPressPaletteButton(_ sender: Any) {
        coordinator?.viewPalette()
    }
    
    
    
}

extension InitialVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
