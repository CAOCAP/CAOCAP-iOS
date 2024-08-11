//
//  AttributesToolKit.swift
//  CAOCAP
//
//  Created by الشيخ عزام on 11/08/2024.
//

import UIKit

class AttributesToolKit: ToolKitVC {
    
    /// The current project being edited in the playground.
    var project: Project?
    
    /// Array of all available Tailwind CSS class names.
    var tailwindClassNames = TailwindCSS.all
    
    //MARK: Outlets
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButtons()
    }
    
    
    override func newState(state: ReduxState) {
        super.newState(state: state)
        updateProjectIfNeeded(from: state)
        refreshUIForCurrentProject()
    }
    
    // MARK: - Helper Functions
    
    /// Updates the project reference if it is not already set.
    ///
    /// - Parameter state: The new state from the Redux store.
    private func updateProjectIfNeeded(from state: ReduxState) {
        if project == nil {
            project = state.openedProject
        }
    }
    
    /// Refreshes the UI elements to reflect the current project's state.
    private func refreshUIForCurrentProject() {
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
extension AttributesToolKit: UIColorPickerViewControllerDelegate {
    
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
extension AttributesToolKit: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

// MARK: - UITextFieldDelegate
extension AttributesToolKit: UITextFieldDelegate {
    
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

