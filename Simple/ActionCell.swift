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

    func configure(withAction action: Action, indexPath: IndexPath, shouldShowCheckBox: Bool) {
  
        nameTextField.placeholder = ""
        nameTextField.text = action.name
        checkBox.tintColor = UIColor(red: 0.42, green: 0.70, blue: 0.88, alpha: 1)
        let isChecked = Bool(action.done!)
        checkBox.isChecked = isChecked
        if isChecked {
            nameTextField.textColor = .lightGray
            nameTextField.isUserInteractionEnabled = false
        } else {
            nameTextField.textColor = .black
            nameTextField.isUserInteractionEnabled = true
        }
        if indexPath.row == 0 || shouldShowCheckBox == true {
            checkBox.isHidden = false
        } else {
            checkBox.isHidden = true
        }
    }
}
