//
//  TemplatesTVC.swift
//  Templates
//
//  Created by Kasey Baughan on 2/23/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit

final class TemplatesTVC: UITableViewController {
    
    // MARK: Required inits for Xibs
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) missing")}
    override var nibName: String? { return String(describing: type(of: self)) }
    
    init(_ config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    // MARK: Data Properties
    private let config: Config
    var templates = [Template]() {
        didSet {
            tableView.reloadData()
        }
    }
    var isReordering: Bool {
        return tableView.isEditing
    }
}

// MARK: Lifecycle
extension TemplatesTVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
    }
}

// MARK: Data Source
extension TemplatesTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let template = templates[indexPath.row]
        let cell = UITableViewCell.dequeue(
            tableViewCell: TemplateTVCell.self,
            tableView: tableView,
            indexPath: indexPath)
        cell.config(with: template,
                    tappedView: { [weak self] in self?.config.tappedView(template) })
        return cell
    }
}

// MARK: Delegate
extension TemplatesTVC {
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let template = templates[indexPath.row]
        config.selected(template)
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TemplateTVCell.rowHeight
    }
}

// MARK: Swiping
extension TemplatesTVC {
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let template = templates[indexPath.row]
        let deleteAction = UIContextualAction(title: "Delete", color: .systemRed) {
            self.config.deleteSwipe(template)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let template = templates[indexPath.row]
        let shareAction = UIContextualAction(title: "Share", color: .systemPurple) {
            self.config.shareSwipe(template)
        }
        let sendTextAction = UIContextualAction(title: "Send Text", color: .systemBlue) {
            self.config.sendTextSwipe(template)
        }
        return UISwipeActionsConfiguration(actions: [sendTextAction, shareAction])
    }
}

// MARK: Editing
extension TemplatesTVC {
    
    func beginEditing() {
        tableView.isEditing = true
    }
    
    func endEditing() {
        tableView.isEditing = false
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        var mTemplates = self.templates
        let template = mTemplates.remove(at: sourceIndexPath.row)
        mTemplates.insert(template, at: destinationIndexPath.row)
        config.reordered(mTemplates)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let template = templates[indexPath.row]
        config.deleteSwipe(template)
    }
}

// MARK: Config
extension TemplatesTVC {
    
    struct Config {
        let selected: (Template) -> ()
        let deleteSwipe: (Template) -> ()
        let shareSwipe: (Template) -> ()
        let sendTextSwipe: (Template) -> ()
        let tappedView: (Template) -> ()
        let reordered: ([Template]) -> ()
    }
}
