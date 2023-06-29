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
            Section(title: "Main", options: [
                .staticCell(option: SettingsOption(title: "doc", icon: UIImage(systemName: "doc.text"), color: .systemBlue, handler: {print("did press")})),
                .switchCell(option: SettingsSwitchOption(title: "save", icon: UIImage(systemName: "flag.square.fill"), color: .systemYellow, handler: {print("did press")}, isOn: false)),
            ]),
            Section(title: "Info", options: [
                .staticCell(option:SettingsOption(title: "test", icon: UIImage(systemName: "info.circle"), color: .systemPink, handler: {print("did press")})),
                .staticCell(option:SettingsOption(title: "test", icon: UIImage(systemName: "info.circle"), color: .systemPink, handler: {print("did press")})),
                .switchCell(option: SettingsSwitchOption(title: "save", icon: UIImage(systemName: "flag.square.fill"), color: .systemYellow, handler: {print("did press")}, isOn: false)),
            ]),
            Section(title: "More", options: [
                .staticCell(option:SettingsOption(title: "test", icon: UIImage(systemName: "info.circle"), color: .systemPink, handler: {print("did press")})),
                .staticCell(option:SettingsOption(title: "test", icon: UIImage(systemName: "info.circle"), color: .systemPink, handler: {print("did press")})),
                .switchCell(option: SettingsSwitchOption(title: "save", icon: UIImage(systemName: "flag.square.fill"), color: .systemYellow, handler: {print("did press")}, isOn: false)),
                .staticCell(option:SettingsOption(title: "test", icon: UIImage(systemName: "info.circle"), color: .systemPink, handler: {print("did press")})),
                .staticCell(option:SettingsOption(title: "test", icon: UIImage(systemName: "info.circle"), color: .systemPink, handler: {print("did press")})),
            ])
        ]
    }

}
