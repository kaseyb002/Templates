//
//  AddEditTemplateVC.swift
//  Templates
//
//  Created by Kasey Baughan on 3/1/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit

final class AddEditTemplateVC: UIViewController {
    
    // MARK: Required inits for Xibs
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) missing")}
    override var nibName: String? { return String(describing: type(of: self)) }
    
    init(_ config: Config,
         navConfig: NavConfig) {
        self.config = config
        self.navConfig = navConfig
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    // MARK: Data Properties
    private let config: Config
    private let navConfig: NavConfig
    private var presetText: String? {
        switch config.mode {
        case .add: return nil
        case .edit(let template): return template.text
        }
    }
    private var text: String {
        return textVC.text
    }
    private var isValid: Bool {
        return !text.isEmpty
    }
    
    // MARK: Views
    @IBOutlet weak private var textView: UIView! {
        didSet {
            embed(textVC, into: textView)
        }
    }
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    private lazy var saveButton = makeSaveButton()
    private lazy var cancelButton = makeCancelButton()
    
    // MARK: Child VCs
    private lazy var textVC = TextViewVC(.init(
        presetText: presetText,
        letterPressed: { [weak self] _ in
            self?.updateSaveButton()
        }
    ))
}

// MARK: Lifecycle
extension AddEditTemplateVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        setupKeyboardHidingShowingNotifications()
        loadTemplateIfNeeded()
        updateSaveButton()
        textVC.focus()
    }
}

// MARK: Actions
extension AddEditTemplateVC {
    
    @objc
    func saveButtonPressed() {
        saveTemplate()
    }
    
    @objc
    func cancelButtonPressed() {
        cancel()
    }
    
    private func cancel() {
        navConfig.done()
    }
    
    private func saveTemplate() {
        guard isValid else {
            okAlert("Needs Text")
            return
        }
        
        switch config.mode {
        case .add:
            addTemplate()
        case .edit(let template):
            edit(template: template)
        }
    }
    
    private func addTemplate() {
        TemplatesAPI.createTemplate(from: text)
        navConfig.done()
    }
    
    private func edit(template: Template) {
        let new = template.update(text: text)
        TemplatesAPI.update(template: new)
        navConfig.done()
    }
}

// MARK: Update UI
extension AddEditTemplateVC {
    
    private func loadTemplateIfNeeded() {
        switch config.mode {
        case .add: title = "Add Template"
        case .edit: title = "Edit Template"
        }
    }
    
    private func updateSaveButton() {
        saveButton.isEnabled = isValid
    }
}

// MARK: Make Buttons
extension AddEditTemplateVC {
    
    private func makeSaveButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveButtonPressed))
    }
    
    private func makeCancelButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelButtonPressed))
    }
}

// MARK: Keyboardable
extension AddEditTemplateVC: Keyboardable {
    
    var bottomConstraints: [NSLayoutConstraint] {
        return [bottomConstraint]
    }
}

// MARK: Config
extension AddEditTemplateVC {
    
    struct Config {
        let mode: Mode
    }
    
    struct NavConfig {
        let done: () -> ()
    }
    
    enum Mode {
        case add
        case edit(Template)
    }
}

