//
//  ActionCell.swift
//  Simple
//
//  Created by Artem Valiev on 11.07.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import Foundation
import UIKit

class ActionCell: UITableViewCell {
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var nameTextField: UITextField!

    func configure(withAction action: Action?, indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            nameTextField.placeholder = "Новое действие"
            nameTextField.text = ""
            checkBox.hidden = true
        } else {
            nameTextField.placeholder = ""
            nameTextField.text = action!.name
            checkBox.tintColor = UIColor(red: 0.42, green: 0.70, blue: 0.88, alpha: 1)
            checkBox.isChecked = Bool(action!.done!)
            if indexPath.row == 0 {
                checkBox.hidden = false
            } else {
                checkBox.hidden = true
            }
        }

    }
}