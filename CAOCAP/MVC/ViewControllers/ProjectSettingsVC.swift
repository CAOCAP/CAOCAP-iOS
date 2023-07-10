//
//  ProjectSettingsVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 29/06/2023.
//

import UIKit

class ProjectSettingsVC: SettingsVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [
            Section(title: "HTML", options: [
                .staticCell(option: SettingsOption(title: "Language", icon: UIImage(systemName: "globe"), color: .systemPink, handler: {print("did press")})),
            ]),
            
            Section(title: "Head", options: [
                .staticCell(option: SettingsOption(title: "Title", icon: UIImage(systemName: "t.square"), color: .systemGray, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Style", icon: UIImage(systemName: "character.cursor.ibeam"), color: .systemGray, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Meta", icon: UIImage(systemName: "text.book.closed"), color: .systemGray2, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Link", icon: UIImage(systemName: "link"), color: .systemGray2, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Script", icon: UIImage(systemName: "terminal"), color: .systemGray3, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Base", icon: UIImage(systemName: "doc"), color: .systemGray3, handler: {print("did press")})),
            ]),
            
            Section(title: "Assets", options: [
                .staticCell(option: SettingsOption(title: "Fonts", icon: UIImage(systemName: "textformat"), color: .systemBlue, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Images", icon: UIImage(systemName: "photo.on.rectangle.angled"), color: .systemBlue, handler: {print("did press")})),
                .staticCell(option: SettingsOption(title: "Videos", icon: UIImage(systemName: "play.rectangle"), color: .systemBlue, handler: {print("did press")})),
            ]),
            
            Section(title: "Save", options: [
                .staticCell(option:SettingsOption(title: "Save", icon: UIImage(systemName: "sdcard"), color: .systemYellow , handler: {print("did press")})),
                .switchCell(option: SettingsSwitchOption(title: "Auto-Save", icon: UIImage(systemName: "arrow.triangle.2.circlepath.circle"), color: .systemOrange, handler: {print("did press")}, isOn: false)),
                .staticCell(option:SettingsOption(title: "Version control system", icon: UIImage(systemName: "externaldrive.badge.icloud"), color: .systemPink, handler: {print("did press")})),
            ]),
            
            Section(title: "Files", options: [
                .staticCell(option:SettingsOption(title: "Import", icon: UIImage(systemName: "doc.badge.plus"), color: .systemGreen, handler: {print("did press")})),
                .staticCell(option:SettingsOption(title: "Export", icon: UIImage(systemName: "square.and.arrow.up"), color: .systemPink, handler: {print("did press")})),
            ]),        ]
    }
    
}
