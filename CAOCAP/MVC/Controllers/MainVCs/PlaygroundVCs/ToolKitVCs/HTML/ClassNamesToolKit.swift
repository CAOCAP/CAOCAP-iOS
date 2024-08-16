//
//  ClassNamesToolKit.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 11/08/2024.
//

import UIKit

class ClassNamesToolKit: ToolKitVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func newState(state: ReduxState) {
        super.newState(state: state)
    }
}

extension ClassNamesToolKit: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Components"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? ComponentTableViewCell else { return UITableViewCell() }
        cell.configure(with: "test")
        return cell
    }
    
    
}
