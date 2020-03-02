//
//  TemplateTVCell.swift
//  Templates
//
//  Created by Kasey Baughan on 2/23/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit

final class TemplateTVCell: UITableViewCell {
    
    @IBOutlet weak private var templateLabel: UILabel!
    @IBOutlet weak private var viewButton: UIButton!
    
    @IBAction private func viewButtonPressed(_ sender: UIButton) {
        tappedView()
    }
    
    static let rowHeight: CGFloat = UITableView.automaticDimension
    
    private var tappedView: (() -> ())!
}

extension TemplateTVCell {
    
    func config(with template: Template,
                tappedView: @escaping () -> ()) {
        templateLabel.text = template.text
        self.tappedView = tappedView
    }
}
