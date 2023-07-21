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
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        sections = [
            Section(title: "Main", options: [
                .staticCell(option: SettingsOption(title: "Language", icon: UIImage(systemName: "globe"), color: .systemPink, handler: {
                    print("did press")
                    
                })),
                .staticCell(option: SettingsOption(title: "Notifications", icon: UIImage(systemName: "bell.badge.fill"), color: .systemRed, handler: {
                    print("did press")
                    
                })),
                .switchCell(option: SettingsSwitchOption(title: "Sounds", icon: UIImage(systemName: "speaker.wave.2.fill"), color: .systemOrange, handler: {
                    print("did press")
                    
                }, isOn: false)),
                .staticCell(option: SettingsOption(title: "What's New?", icon: UIImage(systemName: "sparkles"), color: .systemYellow, handler: {
                    let whatsNewVC = storyboard.instantiateViewController(withIdentifier: "WhatsNewVC")
                    self.present(whatsNewVC, animated: true)
                    
                })),
                .staticCell(option: SettingsOption(title: "Review on AppStore", icon: UIImage(systemName: "star.bubble.fill"), color: .systemBlue, handler: {
                    print("did press")
                    
                })),
                .staticCell(option: SettingsOption(title: "Share App", icon: UIImage(systemName: "square.and.arrow.up.fill"), color: .systemCyan, handler: {
                    guard let url = URL(string: "https://testflight.apple.com/join/UayI188L") else { return }
                    let shareSheetVC = UIActivityViewController(activityItems: [
                    url
                    ], applicationActivities: nil)
                    self.present(shareSheetVC, animated: true)
                })),
            ]),
            Section(title: "contact", options: [
                .staticCell(option: SettingsOption(title: "Help", icon: UIImage(systemName: "questionmark.circle.fill"), color: .systemTeal, handler: {
                    print("did press")
                    
                })),
                .staticCell(option: SettingsOption(title: "Support", icon: UIImage(systemName: "message.fill"), color: .systemMint, handler: {
                    print("did press")
                    
                })),
                .staticCell(option: SettingsOption(title: "Send Feedback", icon: UIImage(systemName: "paperplane.fill"), color: .systemGreen, handler: {
                    print("did press")
                    
                })),
            ]),
            Section(title: "Info", options: [
                .staticCell(option:SettingsOption(title: "Privacy Policy", icon: UIImage(systemName: "lock.shield.fill"), color: .systemGray, handler: {
                    print("did press")
                    
                })),
                .staticCell(option:SettingsOption(title: "Terms Of Use", icon: UIImage(systemName: "doc.on.clipboard.fill"), color: .systemGray, handler: {
                    print("did press")
                    
                })),
                .staticCell(option:SettingsOption(title: "About Us", icon: UIImage(systemName: "info.circle.fill"), color: .systemGray2, handler: {
                    print("did press")
                    
                })),
                .staticCell(option: SettingsOption(title: "Credits", icon: UIImage(systemName: "person.2.fill"), color: .systemGray3, handler: {
                    print("did press")
                    
                })),
            ]),
        ]
        
    }

}

