//
//  PlaygroundVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 03/06/2023.
//

import UIKit
import WebKit
import ReSwift
import SnapKit
import SwiftSoup

class PlaygroundVC: UIViewController, Storyboarded {
    
    /// The current project being edited in the playground.
    var project: Project?
    
    /// Boolean flag to determine if the ViewFinder is currently on.
    var viewFinderIsOn = false
    @IBOutlet var viewFinderViews: [UIView]!
    
    /// The web view used to preview the project's HTML content.
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var resizeIcon: UIImageView!
    @IBOutlet weak var webViewWidthConstraint: NSLayoutConstraint!
    
    /// Undo/Redo button outlets.
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    
    /// Tools view that contains the keyboard and other tools.
    @IBOutlet weak var toolsView: UIView!
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    
    var mindMap: UIMindMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start the Node.js server in a background thread
        NodeJSManager.shared.startNodeServerInBackground()
        
        // Set up gesture recognizer for resizing the web view
        let resizeGR = UIPanGestureRecognizer(target: self, action: #selector(handleResizingWebView(sender:)))
        resizeIcon.addGestureRecognizer(resizeGR)
        
        mindMap = UIMindMap(frame: view.frame, color: .systemBlue)
        mindMap.mindMapDelegate = self
        view.insertSubview(mindMap, at: 0)
        mindMap.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: - WebView
    /// Load the project's web content into the web view
    func loadWebView() {
        guard let document = project?.document else { return }
        do {
            let htmlCode = try document.outerHtml()
            print("loadWebView:", htmlCode)
            webView.loadHTMLString( htmlCode, baseURL: nil)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }
    
    
    // MARK: - WebView Gesture Handling
    
    /// Handle the resizing of the web view when a pan gesture is detected.
    ///
    /// This function adjusts the width of the web view based on the user's touch location.
    /// It ensures the web view width stays within a specified range.
    ///
    /// - Parameter sender: The pan gesture recognizer that triggers this function.
    @objc func handleResizingWebView(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            let touchPoint = sender.location(in: view).x - 20
            if touchPoint > 60 && touchPoint < 240 {
                webViewWidthConstraint.constant = touchPoint
            }
        default:
            if webViewWidthConstraint.constant < 90 {
                webViewWidthConstraint.constant = 80
            } else if webViewWidthConstraint.constant >= 90 && webViewWidthConstraint.constant < 130 {
                webViewWidthConstraint.constant = 120
            } else if webViewWidthConstraint.constant >= 130 && webViewWidthConstraint.constant < 170 {
                webViewWidthConstraint.constant = 160
            } else {
                webViewWidthConstraint.constant = 200
            }
        }
    }
    
    
    // MARK: - Close Button
    /// Dismisses the current view controller.
    @IBAction func didPressCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    // MARK: - ViewFinder
    /// Toggles the ViewFinder feature on or off.
    @IBAction func didPressViewfinderButton(_ sender: UIButton) {
        if viewFinderIsOn {
            sender.setImage(UIImage(systemName: "viewfinder.circle.fill"), for: .normal)
            self.viewFinderViews.forEach { $0.isHidden = false }
            UIView.animate(withDuration: 1) {
                self.viewFinderViews.forEach { $0.alpha = 1 }
            }
        } else {
            sender.setImage(UIImage(systemName: "viewfinder.circle"), for: .normal)
            UIView.animate(withDuration: 1) {
                self.viewFinderViews.forEach { $0.alpha = 0 }
            } completion: { _ in
                self.viewFinderViews.forEach { $0.isHidden = true }
            }
        }
        viewFinderIsOn.toggle()
    }
    
    @IBAction func didPressCoCaptain(_ sender: UIButton) {
        let vc = CoCaptainVC.instantiate()
        self.present(vc, animated: true)
    }
    
    @IBAction func didPressPublish(_ sender: UIButton) {
        let vc = PublishVC.instantiate()
        self.present(vc, animated: true)
    }
    
    
    // MARK: - Undo/Redo Button Actions
    /// Dispatches an undo action to the Redux store.
    @IBAction func didPressUndo(_ sender: UIButton) {
        print("\(#function)ing...")
        ReduxStore.dispatch(UndoAction())
    }
    
    /// Dispatches a redo action to the Redux store.
    @IBAction func didPressRedo(_ sender: UIButton) {
        print("\(#function)ing...")
        ReduxStore.dispatch(RedoAction())
    }
    
    // MARK: - Arrow Button Actions
    /// Handles arrow button presses to update the selected node in the  MindMap.
    ///
    /// - Parameter sender: The button that triggered this action. The button's tag determines the direction.
    @IBAction func didPressArrow(_ sender: UIButton) {
        mindMap.updateSelectedNode(Direction(rawValue: sender.tag))
    }
    
    
}




// MARK: - UIMindMapDelegate
extension PlaygroundVC: UIMindMapDelegate {
    
    /// Handles the removal of a node in the MindMap.
    func didRemoveMindMapNode() {
        loadWebView()
    }
}

extension PlaygroundVC: StoreSubscriber {
    
    /// Subscribes to the Redux store when the view appears.
    override func viewWillAppear(_ animated: Bool) {
        ReduxStore.subscribe(self)
    }
    
    /// Unsubscribes from the Redux store when the view disappears.
    override func viewWillDisappear(_ animated: Bool) {
        ReduxStore.unsubscribe(self)
    }
    
    /// Updates the UI based on the new state from the Redux store.
    ///
    /// - Parameter state: The new state from the Redux store.
    func newState(state: ReduxState) {
        
        updateProjectIfNeeded(from: state)
        
        loadWebView()/*🤔*/
        mindMap.loadBody()
        
        
        projectTitle.text = project?.getDocumentTitle()
    }
    
    // MARK: - Helper Functions
    
    /// Updates the project reference if it is not already set.
    ///
    /// - Parameter state: The new state from the Redux store.
    private func updateProjectIfNeeded(from state: ReduxState) {
        if project == nil {
            project = state.openedProject
            mindMap.project = project
        }
    }
    
}
