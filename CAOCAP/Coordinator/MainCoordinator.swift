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
        let chartsVC = ChartsVC.instantiate()
        let projectsVC = ProjectsVC.instantiate()
        let mainSettingsVC = MainSettingsVC.instantiate()
        
        initialVC.coordinator = self
        chartsVC.viewControllers = [UIHostingController(rootView: UIDashboardView())]
        projectsVC.coordinator = self
        mainSettingsVC.coordinator = self
        
        
        navigationVC.coordinator = self
        navigationVC.viewControllers = [initialVC, chartsVC, projectsVC, mainSettingsVC]
        
        navigationController.pushViewController(navigationVC, animated: false)
    }
    
    func createNewProject() {
        ReduxStore.dispatch(CreateProjectAction(newProject: Project()))
        let vc = MindMapVC.instantiate()
        navigationController.present(vc, animated: true)
    }
    
    func viewMainSettings() {
        let vc = MainSettingsVC.instantiate()
        navigationController.present(vc, animated: true)
    }
    
    func viewProjects() {
        let vc = ProjectsVC.instantiate()
        navigationController.present(vc, animated: true)
    }
    
    func viewPurchase() {
        let vc = PurchaseVC.instantiate()
        navigationController.present(vc, animated: true)
    }
    
    func viewPalette() {
        let vc = PaletteVC.instantiate()
        navigationController.present(vc, animated: true)
    }
    
}
