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
                .staticCell(option: SettingsOption(title: "What's New?", icon: UIImage(systemName: "sparkles"), color: .systemYellow, label: "v5.0.0", handler: {
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
            Section(title: "Info", options: [
                .staticCell(option:SettingsOption(title: "About Us", icon: UIImage(systemName: "info.circle.fill"), color: .systemGray2, handler: {
                    self.coordinator?.viewAboutUs()
                    
                })),
                .staticCell(option: SettingsOption(title: "Credits", icon: UIImage(systemName: "person.2.fill"), color: .systemGray3, handler: {
                    self.coordinator?.viewCredits()
                    
                })),
            ]),
        ]
        
    }

}

