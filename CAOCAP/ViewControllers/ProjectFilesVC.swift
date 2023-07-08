//
//  ProjectFilesVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 08/07/2023.
//

import UIKit

class ProjectFilesVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
    }
}


extension ProjectFilesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "file\(indexPath.row)"
        return cell
    }
    
    
}
