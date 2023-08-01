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
                .staticCell(option: SettingsOption(title: "What's New?", icon: UIImage(systemName: "sparkles"), color: .systemYellow, label: "v5.0.0", handler: {
                    self.coordinator?.viewWhatsNewVC()
                    
                })),
                .staticCell(option: SettingsOption(title: "Review on AppStore", icon: UIImage(systemName: "star.bubble.fill"), color: .systemBlue, handler: {
                    guard let productURL = URL(string: "https://apps.apple.com/app/id1447742145") else { return }
                    var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
                    components?.queryItems = [
                      URLQueryItem(name: "action", value: "write-review")
                    ]
                    guard let writeReviewURL = components?.url else { return }
                    UIApplication.shared.open(writeReviewURL)
                })),
                .staticCell(option: SettingsOption(title: "Share App", icon: UIImage(systemName: "square.and.arrow.up.fill"), color: .systemCyan, handler: {
                    guard let productURL = URL(string: "https://apps.apple.com/app/id1447742145") else { return }
                    let shareSheetVC = UIActivityViewController(activityItems: [
                        productURL
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

