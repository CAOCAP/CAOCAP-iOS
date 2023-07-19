//
//  ProjectsVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 10/06/2023.
//

import UIKit

class ProjectsVC: UIViewController, Storyboarded {
    var coordinator: MainCoordinator?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
    }
}

extension ProjectsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "error: failed to load project name"
        return cell
    }
    
    
}
