//
//  MainSettingsVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 29/06/2023.
//


import UIKit

class MainSettingsVC: SettingsVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [
            Section(title: "Main", options: [
                .staticCell(option: SettingsOption(title: "Notifications", icon: UIImage(systemName: "bell.badge.fill"), color: .systemPink, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Language", icon: UIImage(systemName: "globe"), color: .systemPink, handler: {print("did press")})),
                .switchCell(option: SettingsSwitchOption(title: "Sounds", icon: UIImage(systemName: "speaker.wave.2.fill"), color: .systemYellow, handler: {print("did press")}, isOn: false)),
                .staticCell(option: SettingsOption(title: "What Is New?", icon: UIImage(systemName: "bell.badge.fill"), color: .systemPink, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Review on AppStore", icon: UIImage(systemName: "star.bubble.fill"), color: .systemBlue, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Share App", icon: UIImage(systemName: "star.bubble.fill"), color: .systemBlue, handler: {print("did press")})),
            ]),
            Section(title: "Info", options: [
                .staticCell(option:SettingsOption(title: "Privacy Policy", icon: UIImage(systemName: "info.circle.fill"), color: .systemCyan, handler: {print("did press")})),
                .staticCell(option:SettingsOption(title: "Terms Of Use", icon: UIImage(systemName: "info.circle.fill"), color: .systemCyan, handler: {print("did press")})),
                .staticCell(option:SettingsOption(title: "About Us", icon: UIImage(systemName: "info.circle.fill"), color: .systemCyan, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Credits", icon: UIImage(systemName: "person.2.fill"), color: .systemMint, handler: {print("did press")})),
            ]),
            Section(title: "contact", options: [
                .staticCell(option: SettingsOption(title: "Support", icon: UIImage(systemName: "message.fill"), color: .systemBlue, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Help", icon: UIImage(systemName: "star.bubble.fill"), color: .systemBlue, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Send Feedback", icon: UIImage(systemName: "paperplane.fill"), color: .systemBlue, handler: {print("did press")})),
            ])
        ]
        
    }

}

