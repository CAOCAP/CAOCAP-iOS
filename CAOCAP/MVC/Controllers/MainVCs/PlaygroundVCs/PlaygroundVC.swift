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
    
    /// List of completed challenges for the project.
    var completeChallenges: [String]?
    
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
    @IBOutlet weak var toolsPageControl: UIPageControl!
    
    /// Array to hold the Canvas for HTML, CSS, and JS.
    var canvases = [UICanvas]()
    var htmlMindMap: UIMindMap!
    var cssStyleSheet: UIStyleSheet!
    var jsFlowChart: UIFlowChart!
    
    /// Arrays to hold the keyboard views for HTML, CSS, and JS.
    var htmlToolKitVCs = [ComponentsToolKit.instantiate(),
                          StructureToolKit.instantiate(),
                          AttributesToolKit.instantiate()]
    
    var cssToolKitVCs = [SelectorsToolKit.instantiate(),
                         PropertiesToolKit.instantiate(),
                         StyleToolKit.instantiate()]
    
    var jsToolKitVCs = [EventsToolKit.instantiate(),
                        ConActToolKit.instantiate(),
                        ValueToolKit.instantiate()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up gesture recognizer for resizing the web view
        let resizeGR = UIPanGestureRecognizer(target: self, action: #selector(handleResizingWebView(sender:)))
        resizeIcon.addGestureRecognizer(resizeGR)
        
        setupToolsViewLayout()
        setupCanvasesLayout()
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
    
    
    // MARK: - Canvases Setup
    /// Set up the layout and configuration of the Canvases
    func setupCanvasesLayout() {
        htmlMindMap = UIMindMap(frame: view.frame, color: .systemBlue)
        cssStyleSheet = UIStyleSheet(frame: view.frame, color: .systemPurple)
        jsFlowChart = UIFlowChart(frame: view.frame, color: .systemGreen)
        canvases = [jsFlowChart, htmlMindMap, cssStyleSheet]
        htmlMindMap.mindMapDelegate = self
        cssStyleSheet.styleSheetDelegate = self
        jsFlowChart.flowChartDelegate = self
        canvases.forEach { canvas in
            view.insertSubview(canvas, at: 0)
            canvas.isHidden = true
            canvas.alpha = 0
            canvas.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        htmlMindMap.alpha = 1
        htmlMindMap.isHidden = false
        
    }
    
    
    // MARK: - Tools View Setup
    /// Set up the layout and swipe gestures for the tools view
    func setupToolsViewLayout() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardSwipe(sender:)))
        rightSwipe.direction = .right
        leftSwipe.direction = .left
        upSwipe.direction = .up
        downSwipe.direction = .down
        toolsView.addGestureRecognizer(rightSwipe)
        toolsView.addGestureRecognizer(leftSwipe)
        toolsView.addGestureRecognizer(upSwipe)
        toolsView.addGestureRecognizer(downSwipe)
        

        [htmlToolKitVCs,cssToolKitVCs,jsToolKitVCs].forEach { toolKitVCs in
            toolKitVCs.forEach { toolKitVC in
                addChild(toolKitVC)
                toolKitVC.didMove(toParent: self)
                toolsView.addSubview(toolKitVC.view)
                toolKitVC.view.snp.makeConstraints { make in
                    make.width.height.equalToSuperview()
                }
            }
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
    
    // MARK: - Animate MindMap Transition
    
    var mindmapPreviousIndex = 1
    
    /// Handle changes in the MindMaps segmented control.
    ///
    /// This function animates the transition between different mind maps when the segmented control is changed.
    ///
    /// - Parameter sender: The segmented control that triggers this function.
    @IBAction func didChangeMindMapsSegmentedControl(_ sender: UISegmentedControl) {
        let currentMindMap = canvases[sender.selectedSegmentIndex], previousMindMap = canvases[mindmapPreviousIndex]
        mindmapPreviousIndex = sender.selectedSegmentIndex
        currentMindMap.isHidden = false
        UIView.animate(withDuration: 0.3) {
            currentMindMap.alpha = 1; previousMindMap.alpha = 0
        } completion: { _ in
            previousMindMap.isHidden = true
        }
        
    }
    
    
    // MARK: - Animate Keyboard Transition
    
    var keyboardIndex = 0
    var keyboardPreviousIndex = 0
    
    /// Animate the transition between different custom keyboards.
    ///
    /// This function handles the sliding animation between different keyboards, depending on the selected index.
    ///
    /// - Parameter index: The index of the keyboard to transition to.
    func animateToKeyboard(at index: Int) {
//        keyboardPreviousIndex = keyboardIndex TODO: - 
//        keyboardIndex = index
//        var animationDirection = keyboardIndex > keyboardPreviousIndex
//        if keyboardIndex < 0 { keyboardIndex = htmlToolKitVCs.count - 1 } else if keyboardIndex > htmlToolKitVCs.count - 1 { keyboardIndex = 0 }
//        let currentKeyboard = htmlToolKitVCs[keyboardIndex], previousKeyboard = htmlToolKitVCs[keyboardPreviousIndex]
//        currentKeyboard.isHidden = false
//        currentKeyboard.frame.origin.x = animationDirection ? self.view.frame.width : -self.view.frame.width
//        UIView.animate(withDuration: 0.3) {
//            currentKeyboard.center.x = previousKeyboard.center.x
//            previousKeyboard.frame.origin.x = animationDirection ? -self.view.frame.width : self.view.frame.width
//        } completion: { _ in
//            previousKeyboard.isHidden = true
//        }
    }
    
    // MARK: - Keyboard Swipe Handling
    
    /// Handle page control changes for the custom keyboard views.
    ///
    /// This function animates the transition to the selected page in the page control.
    ///
    /// - Parameter sender: The page control that triggers this function.
    @IBAction func didPressToolsPageControl(_ sender: UIPageControl) {
        if sender.currentPage != keyboardIndex {
            animateToKeyboard(at: sender.currentPage)
        }
    }
    
    /// Handle swipe gestures for navigating between custom keyboard views.
    ///
    /// This function allows the user to swipe left, right, up, or down to change the keyboard view or adjust the tools view height.
    ///
    /// - Parameter sender: The swipe gesture recognizer that triggers this function.
    @objc func handleKeyboardSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                animateToKeyboard(at: keyboardIndex - 1)
                toolsPageControl.currentPage = keyboardIndex
            case .left:
                animateToKeyboard(at: keyboardIndex + 1)
                toolsPageControl.currentPage = keyboardIndex
            case .up:
                if toolsViewHeightConstraint.constant == 40 {
                    //only show 6,7 { h=107 }
                    toolsViewHeightConstraint.constant = 107
//                    for n in 6...7 { TODO: -
//                        let view = structureStackView.arrangedSubviews[n]
//                        view.alpha = 1
//                        view.isHidden = false
//                    }
                } else if toolsViewHeightConstraint.constant == 107 {
                    //show all but not 3,4 { h=255 }
                    toolsViewHeightConstraint.constant = 255
//                    for n in 0...5 { TODO: -
//                        if [3,4].contains(n) { continue }
//                        let view = structureStackView.arrangedSubviews[n]
//                        view.alpha = 1
//                        view.isHidden = false
//                    }
                } else if toolsViewHeightConstraint.constant == 255 {
                    //show all { h=329 }
                    webViewWidthConstraint.constant = 120
                    toolsViewHeightConstraint.constant = 329
//                    for n in 3...4 { TODO: -
//                        let view = structureStackView.arrangedSubviews[n]
//                        view.alpha = 1
//                        view.isHidden = false
//                    }
                }
            case .down:
                if toolsViewHeightConstraint.constant == 107 {
                    //hide all { h=40 }
                    toolsViewHeightConstraint.constant = 40
//                    for n in 6...7 { TODO: -
//                        let view = structureStackView.arrangedSubviews[n]
//                        view.alpha = 0
//                        view.isHidden = true
//                    }
                } else if toolsViewHeightConstraint.constant == 255 {
                    //only show 6,7 { h=107 }
                    toolsViewHeightConstraint.constant = 107
//                    for n in 0...5 { TODO: -
//                        let view = structureStackView.arrangedSubviews[n]
//                        view.alpha = 0
//                        view.isHidden = true
//                    }
                } else if toolsViewHeightConstraint.constant == 329 {
                    //show all but not 3,4 { h=255 }
                    webViewWidthConstraint.constant = 160
                    toolsViewHeightConstraint.constant = 255
//                    for n in 3...4 { TODO: -
//                        let view = structureStackView.arrangedSubviews[n]
//                        view.alpha = 0
//                        view.isHidden = true
//                    }
                }
            default:
                break
            }
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
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
    /// Handles arrow button presses to update the selected node in the appropriate MindMap.
    ///
    /// - Parameter sender: The button that triggered this action. The button's tag determines the direction.
    @IBAction func didPressArrow(_ sender: UIButton) {
        if !htmlMindMap.isHidden {
            htmlMindMap.updateSelectedNode(Direction(rawValue: sender.tag))
        } else if !cssStyleSheet.isHidden {
            cssStyleSheet.updateSelectedNode(Direction(rawValue: sender.tag))
        } else {
            jsFlowChart.updateSelectedNode(Direction(rawValue: sender.tag))
        }
    }
    
    
}




// MARK: - UIMindMapDelegate
extension PlaygroundVC: UIMindMapDelegate {
    
    /// Handles the removal of a node in the MindMap.
    func didRemoveMindMapNode() {
        loadWebView()
    }
}

// MARK: - UIFlowChartDelegate
extension PlaygroundVC: UIFlowChartDelegate {
    
    /// Handles the removal of a node in the FlowChart.
    func didRemoveFlowChartNode() {
        loadWebView()
    }
}

// MARK: - UIStyleSheetDelegate
extension PlaygroundVC: UIStyleSheetDelegate {
    
    /// Handles the removal of a node in the StyleSheet.
    func didRemoveStyleSheetNode() {
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
        handleDailyChallenges(with: state)
        
        loadWebView()/*🤔*/
        htmlMindMap.loadBody()
        cssStyleSheet.loadSelector()
        jsFlowChart.loadEvent()
        
        
        projectTitle.text = project?.getDocumentTitle()
    }
    
    // MARK: - Helper Functions
    
    /// Updates the project reference if it is not already set.
    ///
    /// - Parameter state: The new state from the Redux store.
    private func updateProjectIfNeeded(from state: ReduxState) {
        if project == nil {
            project = state.openedProject
            htmlMindMap.project = project
            cssStyleSheet.project = project
            jsFlowChart.project = project
        }
    }
    
    
    // MARK: - Daily Challenge Completion Handling
    /// Handles daily challenges completion and triggers animations if necessary.
    private func handleDailyChallenges(with state: ReduxState) {
        guard let openedProject = state.openedProject else { return }

        for challenge in state.dailyChallenges {
            if challenge.isComplete { continue }
            
            if let docString = openedProject.getOuterHtml(), docString.contains(challenge.regex) {
                view.presentConfettiAnimation()
                challenge.isComplete = true
            }
        }
    }
}
