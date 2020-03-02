//
//  MyTemplatesVC.swift
//  Templates
//
//  Created by Kasey Baughan on 2/23/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit

final class MyTemplatesVC: UIViewController {
    
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
    private let haptic = UIImpactFeedbackGenerator(style: .medium)

    // MARK: Views
    @IBOutlet weak private var containerView: UIView! {
        didSet {
            embed(templatesTVC, into: containerView)
        }
    }
    private lazy var addButton = makeAddButton()
    private lazy var editButton = makeEditButton()
    private lazy var doneButton = makeDoneButton()
    
    // MARK: Child VCs
    private lazy var templatesTVC = TemplatesTVC(.init(
        selected: { [weak self] in
            self?.select(template: $0)
        },
        deleteSwipe: { [weak self] in
            self?.delete(template: $0)
        },
        shareSwipe: { [weak self] in
            self?.share(template: $0)
        },
        sendTextSwipe: { [weak self] in
            self?.sendText(template: $0)
        },
        tappedView: { [weak self] in
            self?.view(template: $0)
        },
        reordered: { [weak self] in
            self?.reordered(templates: $0)
        }))
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Lifecycle
extension MyTemplatesVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Templates"
        navigationItem.rightBarButtonItem = addButton
        updateEditButton()
        setupSubscriptions()
        loadData()
    }
}

// MARK: Data Ops
extension MyTemplatesVC {
    
    private func loadData() {
        let templates = TemplatesAPI.getTemplates()
        templatesTVC.templates = TemplatesAPI.getTemplates()
    }
}

// MARK: Actions
extension MyTemplatesVC {
    
    private func select(template: Template) {
        UIPasteboard.general.string = template.text
        okAlert("Copied", message: template.text)
        haptic.impactOccurred()
    }
    
    private func view(template: Template) {
        navConfig.tappedViewTemplate(.init(template: template))
    }
    
    private func delete(template: Template) {
        TemplatesAPI.delete(template: template)
    }
    
    private func share(template: Template) {
        share(text: template.text)
    }
    
    private func sendText(template: Template) {
        navConfig.tappedSendTemplate(template)
    }
    
    private func reordered(templates: [Template]) {
        TemplatesAPI.save(templates: templates)
    }
    
    @objc
    func addButtonPressed() {
        navConfig.tappedAddTemplate(.init(mode: .add))
    }
    
    @objc
    func editButtonPressed() {
        templatesTVC.beginEditing()
        updateEditButton()
    }
    
    @objc
    func doneButtonPressed() {
        templatesTVC.endEditing()
        updateEditButton()
    }
}

// MARK: Subscriptions
extension MyTemplatesVC {
    
    private func setupSubscriptions() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(templatesUpdated),
            name: .templatesUpdated,
            object: nil)
    }
    
    @objc
    func templatesUpdated() {
        loadData()
    }
    
    private func updateEditButton() {
        if templatesTVC.isReordering {
            navigationItem.leftBarButtonItem = doneButton
            return
        }
        
        navigationItem.leftBarButtonItem = editButton
    }
}

// MARK: Button Makers
extension MyTemplatesVC {
    
    private func makeAddButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed))
    }
    
    private func makeEditButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editButtonPressed))
    }
    
    private func makeDoneButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonPressed))
    }
}

// MARK: Config
extension MyTemplatesVC {
    
    struct Config {
        
    }
    
    struct NavConfig {
        let tappedViewTemplate: (ViewTemplateFlow.Config) -> ()
        let tappedSendTemplate: (Template) -> ()
        let tappedAddTemplate: (AddEditTemplateVC.Config) -> ()
    }
}

