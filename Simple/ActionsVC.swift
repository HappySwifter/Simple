//
//  DetailViewController.swift
//  Simple
//
//  Created by Артем Валиев on 29.06.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import UIKit

class ActionsVC: UITableViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var actionName: String?

    var goal: Goal!
    var actions = [Action]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .OnDrag
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItems = [self.editButtonItem(), addButton]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    func insertNewObject(sender: AnyObject) {
        
//        let alert = UIAlertController(title: "Новое действие", message: "", preferredStyle: .Alert)
//        alert.addTextFieldWithConfigurationHandler { (textField) in
//            textField.placeholder = "Название"
//            textField.delegate = self
//        }
//        let action = UIAlertAction(title: "OK", style: .Default) { [weak self] (action) in
//            guard let sSelf = self where sSelf.actionName?.characters.count > 0 else { return }
//            if let actionName = sSelf.actionName {
//                
//            }
//            
//        }
//        alert.addAction(action)
//        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func checkBoxTapped(sender: CheckBox) {
        let indexPath = indexPathForView(sender)
        let action = actions[indexPath.row]
        action.togleDone()
        sender.isChecked = !sender.isChecked
        
    }
    
    func indexPathForView(view: UIView) -> NSIndexPath {
        let viewOrigin = view.bounds.origin
        let viewLocation = tableView.convertPoint(viewOrigin, fromView: view)
        return tableView.indexPathForRowAtPoint(viewLocation)!
    }
    
    func refreshData() {        
        let tempActions = goal.actions?.allObjects as! [Action]
        actions = tempActions.sort { Int($0.0.priority!) > Int($0.1.priority!) }
        
        tableView.reloadData()
    }

}

extension ActionsVC {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return goal.actions!.count
        }
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ActionCell), forIndexPath: indexPath) as! ActionCell
        if indexPath.section == 0 {
            cell.configure(withAction: nil, indexPath: indexPath)
        } else {
            let action = actions[indexPath.row]
            cell.configure(withAction: action, indexPath: indexPath)
        }
        cell.nameTextField.delegate = self
        return cell
    }
    
    
    
    
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let action = actions[indexPath.row]
            action.deleteAction()
            refreshData()
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        swap(&actions[sourceIndexPath.row], &actions[destinationIndexPath.row])
        for (index, action) in actions.reverse().enumerate() {
            action.priority = index
        }
        Model.instanse.saveContext()
        refreshData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ActionsVC: UITextFieldDelegate {




    
    func textFieldDidBeginEditing(textField: UITextField) {
//        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        defer {
//            activeTextField = nil
        }
        
        guard let text = textField.text else { return }
        
        let indexPath = indexPathForView(textField)
        
        if indexPath.section > 0 {
//            let listItem = listPresenter.presentedListItems[indexPath!.row - 1]
            
//            listPresenter.updateListItem(listItem, withText: text)
            //rename
        }
        else if !text.isEmpty {
            
            Model.instanse.insertAction(goal, name: text)
            refreshData()
//            listPresenter.insertListItem(listItem)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let indexPath = indexPathForView(textField)
        
        // The 'add item' row can always dismiss the keyboard.
        if indexPath.section == 0 {
            textField.resignFirstResponder()
            return true
        }
        // An item must have text to dismiss the keyboard.
        guard let text = textField.text where !text.isEmpty else { return false }
        textField.resignFirstResponder()
        return true
    }
}





//public extension UIColor {
//    private static let colorMapping = [
//        List.Color.Gray:   AppColor.darkGrayColor(),
//        List.Color.Blue:   AppColor(red: 0.42, green: 0.70, blue: 0.88, alpha: 1),
//        List.Color.Green:  AppColor(red: 0.71, green: 0.84, blue: 0.31, alpha: 1),
//        List.Color.Yellow: AppColor(red: 0.95, green: 0.88, blue: 0.15, alpha: 1),
//        List.Color.Orange: AppColor(red: 0.96, green: 0.63, blue: 0.20, alpha: 1),
//        List.Color.Red:    AppColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1)
//    ]
//    
//    private static let notificationCenterColorMapping = [
//        List.Color.Gray:   AppColor.lightGrayColor(),
//        List.Color.Blue:   AppColor(red: 0.42, green: 0.70, blue: 0.88, alpha: 1),
//        List.Color.Green:  AppColor(red: 0.71, green: 0.84, blue: 0.31, alpha: 1),
//        List.Color.Yellow: AppColor(red: 0.95, green: 0.88, blue: 0.15, alpha: 1),
//        List.Color.Orange: AppColor(red: 0.96, green: 0.63, blue: 0.20, alpha: 1),
//        List.Color.Red:    AppColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1)
//    ]
//    
//    
//}