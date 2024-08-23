//
//  ContainerVC.swift
//  taken from AtomiCube
//
//  Created by Azzam AL-Rashed on 14/09/2022.
//
import UIKit

/// A `UIViewController` subclass that acts as a container for an array of child `UIViewController` instances.
/// This class is particularly useful for embedding multiple view controllers, including `UIHostingController`
/// for SwiftUI views, within a single parent view controller.
class ContainerVC: UIViewController {

    /// A container `UIView` that holds all the child view controllers' views.
    var container = UIView(frame: .zero)
    
    /// An array of `UIViewController` instances that will be added as child view controllers to this container.
    var viewControllers = [UIViewController]()
    
    /// Called after the controller's view is loaded into memory.
    /// - This method sets up the initial configuration of the `container` view,
    ///   positioning it to match the bounds of the parent view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the container's frame to match the bounds of the main view
        container.frame = view.bounds
        
        // Insert the container view as the first subview of the main view
        view.insertSubview(container, at: 0)
    }
    
    /// Called to notify the view controller that its view has just laid out its subviews.
    /// - This method is responsible for adding the child view controllers' views to the container view
    ///   and ensuring they are properly positioned within the container.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Add the child view controllers' views to the container view
        addSubViewControllers()
    }
    
    /// Adds all view controllers in `viewControllers` as child view controllers.
    /// - This method iterates through the `viewControllers` array, setting up each child view controller's view
    ///   to fill the container and adding it to the view hierarchy. It also properly manages the parent-child
    ///   relationship between the container and the child view controllers.
    private func addSubViewControllers() {
        for viewController in viewControllers {
            // Set each child view controller's view to match the bounds of the container
            viewController.view.frame = view.bounds
            
            // Add the child view controller's view to the container
            container.addSubview(viewController.view)
            
            // Add the child view controller to the parent (self)
            addChild(viewController)
            
            // Notify the child view controller that it has been moved to a parent
            viewController.didMove(toParent: self)
        }
    }

}
