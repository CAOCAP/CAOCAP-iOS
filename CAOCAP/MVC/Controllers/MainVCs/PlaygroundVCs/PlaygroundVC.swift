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
    
    /// Array of all available Tailwind CSS class names.
    var tailwindClassNames = TailwindCSS.all
    
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
    var htmlKeyboardViews = [UIView]()
    var cssKeyboardViews = [UIView]()
    var jsKeyboardViews = [UIView]()
    
    //MARK: HTML Keyboard Outlets
    @IBOutlet weak var structureKeyboardView: UIView!
    @IBOutlet weak var structureStackView: UIStackView!
    
    @IBOutlet weak var attributesKeyboardView: UIView!
    @IBOutlet weak var attributesStackView: UIStackView!
    @IBOutlet weak var attributesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet var textDecorationButtons: [UIButton]!
    @IBOutlet weak var textAlignmentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var semanticButton: UIButton!
    @IBOutlet weak var listStyleButton: UIButton!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var backgroundColorWell: UIColorWell!
    @IBOutlet weak var textColorWell: UIColorWell!
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var tailwindCollectionView: UICollectionView!
    
    //MARK: CSS Keyboard Outlets
    @IBOutlet weak var selectorsKeyboardView: UIView!
    @IBOutlet weak var selectorsStackView: UIStackView!
    
    //MARK: JS Keyboard Outlets
    @IBOutlet weak var logicKeyboardView: UIView!
    @IBOutlet weak var logicStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up gesture recognizer for resizing the web view
        let resizeGR = UIPanGestureRecognizer(target: self, action: #selector(handleResizingWebView(sender:)))
        resizeIcon.addGestureRecognizer(resizeGR)
        
        setupToolsViewLayout()
        setupCanvasesLayout()
        setupMenuButtons()
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
        
        htmlKeyboardViews = [structureKeyboardView, attributesKeyboardView]
//        cssKeyboardViews = [selectorsKeyboardView] TODO: -
//        jsKeyboardViews = [logicKeyboardView] TODO: - 
        
        [htmlKeyboardViews,cssKeyboardViews,jsKeyboardViews].forEach { keyboardViews in
            keyboardViews.forEach { view in
                toolsView.addSubview(view)
                view.snp.makeConstraints { make in
                    make.width.height.equalToSuperview()
                }
            }
        }
    }
    
    
    // MARK: - Menu Buttons
    /// Set up the menu buttons for type, semantic, and list style options.
    func setupMenuButtons() {
        //TODO: clean/refactor /replace with popovers menu 🛠️
        var typeArray = [
            UIAction(title: "type 1", state: .on, handler: { print($0.title) }),
            UIAction(title: "type 2", state: .off, handler: { print($0.title) }),
            UIAction(title: "type 3", state: .off, handler: { print($0.title) }),
        ]
        
        var semanticArray = [
            UIAction(title: "semantic 1", state: .on, handler: { print($0.title) }),
            UIAction(title: "semantic 2", state: .off, handler: { print($0.title) }),
            UIAction(title: "semantic 3", state: .off, handler: { print($0.title) }),
        ]
        
        var listStyleArray = [
            UIAction(title: "none", state: .on, handler: { print($0.title) }),
            UIAction(title: "disc", state: .off, handler: { print($0.title) }),
            UIAction(title: "decimal", state: .off, handler: { print($0.title) }),
        ]
        
        typeButton.menu = UIMenu(title: "", options: .displayInline, children: typeArray)
        semanticButton.menu = UIMenu(title: "", options: .displayInline, children: semanticArray)
        listStyleButton.menu = UIMenu(title: "", options: .displayInline, children: listStyleArray)
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
        keyboardPreviousIndex = keyboardIndex
        keyboardIndex = index
        var animationDirection = keyboardIndex > keyboardPreviousIndex
        if keyboardIndex < 0 { keyboardIndex = htmlKeyboardViews.count - 1 } else if keyboardIndex > htmlKeyboardViews.count - 1 { keyboardIndex = 0 }
        let currentKeyboard = htmlKeyboardViews[keyboardIndex], previousKeyboard = htmlKeyboardViews[keyboardPreviousIndex]
        currentKeyboard.isHidden = false
        currentKeyboard.frame.origin.x = animationDirection ? self.view.frame.width : -self.view.frame.width
        UIView.animate(withDuration: 0.3) {
            currentKeyboard.center.x = previousKeyboard.center.x
            previousKeyboard.frame.origin.x = animationDirection ? -self.view.frame.width : self.view.frame.width
        } completion: { _ in
            previousKeyboard.isHidden = true
        }
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
                    for n in 6...7 {
                        let view = structureStackView.arrangedSubviews[n]
                        view.alpha = 1
                        view.isHidden = false
                    }
                } else if toolsViewHeightConstraint.constant == 107 {
                    //show all but not 3,4 { h=255 }
                    toolsViewHeightConstraint.constant = 255
                    for n in 0...5 {
                        if [3,4].contains(n) { continue }
                        let view = structureStackView.arrangedSubviews[n]
                        view.alpha = 1
                        view.isHidden = false
                    }
                } else if toolsViewHeightConstraint.constant == 255 {
                    //show all { h=329 }
                    webViewWidthConstraint.constant = 120
                    toolsViewHeightConstraint.constant = 329
                    for n in 3...4 {
                        let view = structureStackView.arrangedSubviews[n]
                        view.alpha = 1
                        view.isHidden = false
                    }
                }
            case .down:
                if toolsViewHeightConstraint.constant == 107 {
                    //hide all { h=40 }
                    toolsViewHeightConstraint.constant = 40
                    for n in 6...7 {
                        let view = structureStackView.arrangedSubviews[n]
                        view.alpha = 0
                        view.isHidden = true
                    }
                } else if toolsViewHeightConstraint.constant == 255 {
                    //only show 6,7 { h=107 }
                    toolsViewHeightConstraint.constant = 107
                    for n in 0...5 {
                        let view = structureStackView.arrangedSubviews[n]
                        view.alpha = 0
                        view.isHidden = true
                    }
                } else if toolsViewHeightConstraint.constant == 329 {
                    //show all but not 3,4 { h=255 }
                    webViewWidthConstraint.constant = 160
                    toolsViewHeightConstraint.constant = 255
                    for n in 3...4 {
                        let view = structureStackView.arrangedSubviews[n]
                        view.alpha = 0
                        view.isHidden = true
                    }
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
    
    // MARK: - HTML Keyboard Button Actions
    /// Adds an HTML element to the current MindMap.
    ///
    /// - Parameter sender: The button that triggered this action. The button's tag determines the HTML element to add.
    @IBAction func didPressAddElement(_ sender: UIButton) {
        print("\(#function)ing...")
        // TODO: Consider externalizing the HTML tags array for better reusability.
        let htmlTags = [
            "span","canvas","div",
            "button","a","input",
            "textArea","form","label",
            "option","legend","select",
            "fieldSet","optGroup","output",
            "video","img","audio",
            "li","h1","p",
            "ul","br","hr",
        ]
        if sender.tag < htmlTags.count {
            htmlMindMap.add(tag: htmlTags[sender.tag])
        }
    }
    
    // MARK: - JavaScript Keyboard Button Actions
    
    /// Handles the addition of an event node in the JS MindMap.
    @IBAction func didPressAddEvent(_ sender: UIButton) {
        print("\(#function)ing...")
        // TODO: Implement event node addition logic.
    }
    
    /// Handles the addition of an action node in the JS MindMap.
    @IBAction func didPressAddAction(_ sender: UIButton) {
        print("\(#function)ing...")
        // TODO: Implement action node addition logic.
    }
    
    /// Handles the addition of a condition node in the JS MindMap.
    @IBAction func didPressAddCondition(_ sender: UIButton) {
        print("\(#function)ing...")
        // TODO: Implement condition node addition logic.
    }
    
    /// Handles the addition of a value node in the JS MindMap.
    @IBAction func didPressAddValue(_ sender: UIButton) {
        print("\(#function)ing...")
        // TODO: Implement value node addition logic.
    }
    
    
    // MARK: - AttributesView Handling
    
    /// Changes the view displayed based on the selected segment in the AttributesView segmented control.
    ///
    /// - Parameter sender: The segmented control that triggered this action.
    @IBAction func didChangeAttributesViewSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            attributesStackView.arrangedSubviews[1].isHidden = false
            attributesStackView.arrangedSubviews[2].isHidden = true
            attributesStackView.arrangedSubviews[3].isHidden = true
        case 1:
            attributesStackView.arrangedSubviews[1].isHidden = true
            attributesStackView.arrangedSubviews[2].isHidden = false
            attributesStackView.arrangedSubviews[3].isHidden = true
        default:
            attributesStackView.arrangedSubviews[1].isHidden = true
            attributesStackView.arrangedSubviews[2].isHidden = true
            attributesStackView.arrangedSubviews[3].isHidden = false
        }
    }
    
    /// Toggles the text decoration on or off for a given button.
    ///
    /// - Parameters:
    ///   - button: The button representing the text decoration.
    ///   - turnOn: A boolean value indicating whether to turn the decoration on or off.
    func toggleTextDecoration(button: UIButton, turnOn: Bool) {
        button.tintColor = turnOn ? .systemBlue : .label
    }
    
    /// Toggles the text decoration for the selected element based on the button pressed.
    ///
    /// - Parameter sender: The button that triggered this action.
    @IBAction func didPressTextDecoration(_ sender: UIButton) {
        print("\(#function)ing...")
        guard let project = project else { return }
        let textDecorations = TextDecoration.allCases
        
        ReduxStore.dispatch(UpdateAction(handler: {
            project.toggleSelectedElementText(decoration: textDecorations[sender.tag])
        }))
        
    }
    
    /// Changes the text alignment of the selected element based on the selected segment in the segmented control.
    ///
    /// - Parameter sender: The segmented control that triggered this action.
    @IBAction func didChangeTextAlignmentSegmentedControl(_ sender: UISegmentedControl) {
        guard let project = project else { return }
        let selectedAlignment = TailwindCSS.textAlign[sender.selectedSegmentIndex]
        ReduxStore.dispatch(UpdateAction(handler: {
            project.setSelectedElementText(alignment: selectedAlignment)
        }))
    }
    
    
    var selectedColorWell: UIColorWell?
    /// Presents the color picker for selecting text or background color.
    ///
    /// - Parameter sender: The button that triggered this action.
    @IBAction func didPressSelectColorButton(_ sender: UIButton) {
        selectedColorWell = sender.tag == 0 ? textColorWell : backgroundColorWell
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    /// Toggles the visibility of the selected element.
    @IBAction func didChangeHiddenSwitch(_ sender: UISwitch) {
        guard let project = project else { return }
        ReduxStore.dispatch(UpdateAction(handler: {
            project.setSelectedElementHidden(sender.isOn)
        }))
    }
    
    
}

// MARK: - UIColorPickerViewControllerDelegate
extension PlaygroundVC: UIColorPickerViewControllerDelegate {
    
    /// Handles the color selection in the color picker view controller.
    ///
    /// - Parameters:
    ///   - viewController: The color picker view controller.
    ///   - color: The selected color.
    ///   - continuously: A boolean value indicating whether the color selection is continuous.
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        guard !continuously else { return }
        guard let project = project else { return }
        switch selectedColorWell {
        case textColorWell:
            textColorWell.selectedColor = color
            ReduxStore.dispatch(UpdateAction(handler: {
                project.setSelectedElementText(color: color)
            }))
        case backgroundColorWell:
            backgroundColorWell.selectedColor = color
            ReduxStore.dispatch(UpdateAction(handler: {
                project.setSelectedElementBackground(color: color)
            }))
        default:
            break
        }
        
    }
}

// MARK: - UICollectionViewDelegate
extension PlaygroundVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// Returns the number of sections in the collection view.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tailwindClassNames.count
    }
    
    /// Returns the number of items in a given section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tailwindClassNames[section].array.count
    }
    
    /// Configures and returns the cell for the given index path.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tailwindCell", for: indexPath) as? TailwindCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(title: tailwindClassNames[indexPath.section].array[indexPath.row])
        return cell
    }
    
    /// Returns the size for the item at the specified index path.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2) - 20, height: 30)
    }
    
    /// Handles the selection of an item in the collection view.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let project = project else { return }
        ReduxStore.dispatch(UpdateAction(handler: {
            project.toggleSelectedElement(className: self.tailwindClassNames[indexPath.section].array[indexPath.row])
        }))
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


// MARK: - UITextFieldDelegate
extension PlaygroundVC: UITextFieldDelegate {
    
    /// Handles the return key press event on the text field.
    ///
    /// - Parameter textField: The text field whose return button was pressed.
    /// - Returns: A boolean value indicating whether the text field should process the return button press.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    /// Handles the event when a HTML element text content editing ends.
    ///
    /// - Parameter sender: The text field that triggered the event.
    @IBAction func didEndEditingTextContent(_ sender: UITextField) {
        guard let project = project, let text = sender.text else { return }
        ReduxStore.dispatch(UpdateAction(handler: {
            project.setSelectedElementText(content: text)
        }))
    }
    
    /// Handles the event when a HTML element source editing ends.
    ///
    /// - Parameter sender: The text field that triggered the event.
    @IBAction func didEndEditingElementSource(_ sender: UITextField) {
        guard let project = project, let text = sender.text else { return }
        ReduxStore.dispatch(UpdateAction(handler: {
            project.setSelectedElement(source: text)
        }))
    }
    
    /// Filters the Tailwind classes based on the search query.
    ///
    /// - Parameter sender: The text field that triggered the event.
    @IBAction func editingTailwindSearch(_ sender: UITextField) {
        guard let searchQuery = sender.text else { return }
        tailwindClassNames = TailwindCSS.all // TODO: refactor this ugly code 🫣
        if !searchQuery.isEmpty {
            var filteredClassNames = [String]()
            for classNameSet in tailwindClassNames {
                filteredClassNames += classNameSet.array.filter { $0.contains(searchQuery)}
            }
            tailwindClassNames = [(name: .none, array: filteredClassNames)]
        }
        
        tailwindCollectionView.reloadData()
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
        
        refreshUIForCurrentProject()
        
    }
    
    // MARK: - Helper Functions
    
    /// Updates the project reference if it is not already set.
    ///
    /// - Parameter state: The new state from the Redux store.
    private func updateProjectIfNeeded(from state: ReduxState) {
        if project == nil {
            project = state.openedProject
            htmlMindMap.project = project
        }
    }
    
    /// Refreshes the UI elements to reflect the current project's state.
    private func refreshUIForCurrentProject() {
        projectTitle.text = project?.getDocumentTitle()
        
        updateContentTextField()
        updateTextDecorationButtons()
        updateTextAlignmentSegmentedControl()
        updateTypeButton()
        updateListStyleButton()
        updateSemanticButton()
        updateSourceTextField()
        updateIDTextField()
        updateColorWells()
        updateHiddenSwitch()
    }

    /// Updates the content text field with the selected element's text.
    private func updateContentTextField() {
        if let selectedElementText = project?.getSelectedElement()?.ownText() {
            contentTextField.text = selectedElementText
        }
    }
    
    /// Updates the text decoration buttons based on the selected element's decorations.
    private func updateTextDecorationButtons() {
        if let selectedElementTextDecorations = project?.getSelectedElementTextDecorations() {
            textDecorationButtons.enumerated().forEach { (index, button) in
                let decoration = TextDecoration.allCases[index]
                toggleTextDecoration(button: button, turnOn: selectedElementTextDecorations.contains(decoration))
            }
        }
    }

    /// Updates the segmented control for text alignment based on the selected element's alignment.
    private func updateTextAlignmentSegmentedControl() {
        if let selectedElementTextAlignment = project?.getSelectedElementTextAlignment(),
           let index = TailwindCSS.textAlign.firstIndex(of: selectedElementTextAlignment) {
            textAlignmentSegmentedControl.selectedSegmentIndex = index
        } else {
            textAlignmentSegmentedControl.selectedSegmentIndex = 0
        }
    }

    /// Updates the type button with the selected element's type.
    private func updateTypeButton() {
        if let selectedElementType = project?.getSelectedElementType() {
            typeButton.setTitle(selectedElementType, for: .normal)
        }
    }

    /// Updates the list style button with the selected element's list style.
    private func updateListStyleButton() {
        if let selectedElementListStyle = project?.getSelectedElementListStyle() {
            listStyleButton.setTitle(selectedElementListStyle, for: .normal)
        }
    }

    /// Updates the semantic button with the selected element's semantic type.
    private func updateSemanticButton() {
        if let selectedElementSemantic = project?.getSelectedElementSemantic() {
            semanticButton.setTitle(selectedElementSemantic, for: .normal)
        }
    }

    /// Updates the source text field with the selected element's source.
    private func updateSourceTextField() {
        if let selectedElementSource = project?.getSelectedElementSource() {
            sourceTextField.text = selectedElementSource
        }
    }

    /// Updates the ID text field's placeholder with the selected element's ID.
    private func updateIDTextField() {
        idTextField.placeholder = project?.selectedElementID
    }

    /// Updates the color wells based on the selected element's background and text colors.
    ///
    /// - Note: The color wells are currently commented out for future implementation.
    private func updateColorWells() {
        // TODO: update the backgroundColorWell & textColorWell selected color
        if let backgroundColor = project?.getSelectedElementBackgroundColor() {
            // backgroundColorWell.selectedColor = backgroundColor
        }
        
        if let textColor = project?.getSelectedElementTextColor() {
            // textColorWell.selectedColor = textColor
        }
    }

    /// Updates the state of the hidden switch based on the selected element's hidden property.
    private func updateHiddenSwitch() {
        if let isHidden = project?.isSelectedElementHidden() {
            hiddenSwitch.isOn = isHidden
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
