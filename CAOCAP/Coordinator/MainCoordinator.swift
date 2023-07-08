//
//  MainCoordinator.swift
//  taken from AtomiCube
//
//  Created by Azzam AL-Rashed on 03/09/2022.
//

import UIKit
import SwiftUI

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    //MARK: Initial View Controller
    func start() {
        let navigationVC = NavigationVC.instantiate()
        
        let initialVC = InitialVC.instantiate()
        
        navigationVC.coordinator = self
        navigationVC.viewControllers = [initialVC]
        navigationController.pushViewController(navigationVC, animated: false)
    }
    
}
