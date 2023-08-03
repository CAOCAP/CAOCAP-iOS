//
//  CreditsVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 21/07/2023.
//

import UIKit

struct Credits {
    let title: String
    let contributors: [(name: String, profession: String)]
}

class CreditsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, Storyboarded {
    var coordinator: MainCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    var credits = [
        Credits(title: "C-Squad", contributors: [
            (name: "Azzam Al-Rashed", profession: "Software Engineer"),
            (name: "Meshal Al-Fiez", profession: "Digital Artist"),
            (name: "Anas Al-Qassim", profession: "Software Engineer"),
            (name: "Omar Al-Zahrani", profession: "Software Engineer"),
            (name: "MSHARI Al-Zahrani", profession: "Software Engineer"),
            (name: "Feras Al-Nowiser", profession: "Software Engineer"),
            (name: "Muhammad Al-Mujtaba", profession: "Software Engineer"),
            (name: "Faisal Al-Thuwaini", profession: "Digital Artist"),
            (name: "Saleh Al-Thini", profession: "Software Engineer"),
            (name: "Ibrahim Al-Jumaiah", profession: "Software Engineer"),
        ]),

        Credits(title: "Special Thanks", contributors: [
            (name: "Mom", profession: ""),
            (name: "Dad", profession: ""),
        ]),
        
        Credits(title: "Third Party Code", contributors: [
            (name: "SwiftSoup", profession: ""),
            (name: "ReSwift", profession: ""),
            (name: "Firebase", profession: ""),
            (name: "Realm", profession: ""),
            (name: "Lottie", profession: ""),
            (name: "SnapKit", profession: ""),
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset.top = 40
        tableView.contentInset.bottom = 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return credits.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits[section].contributors.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return credits[section].title
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = credits[indexPath.section].contributors[indexPath.row].name
        configuration.secondaryText = credits[indexPath.section].contributors[indexPath.row].profession
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
