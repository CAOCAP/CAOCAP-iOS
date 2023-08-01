//
//  CreditsVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 21/07/2023.
//

import UIKit

struct Credits {
    let title: String
    let names: [String]
}

class CreditsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, Storyboarded {
    var coordinator: MainCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    var credits = [Credits(title: "team", names: ["Azzam Rashed Alrashed", "Omar Abdullah Al-Zahrani"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset.top = 40
        tableView.contentInset.bottom = 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return credits.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits[section].names.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return credits[section].title
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = credits[indexPath.section].names[indexPath.row]
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
