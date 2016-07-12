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
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItems = [self.editButtonItem(), addButton]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    func insertNewObject(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Новое действие", message: "", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Название"
            textField.delegate = self
        }
        let action = UIAlertAction(title: "OK", style: .Default) { [weak self] (action) in
            guard let sSelf = self where sSelf.actionName?.characters.count > 0 else { return }
            if let actionName = sSelf.actionName {
                Model.instanse.insertAction(sSelf.goal, name: actionName)
                sSelf.refreshData()
            }
            
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goal.actions!.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActionCell", forIndexPath: indexPath)
        cell.textLabel?.text = actions[indexPath.row].name
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
        
    }
    
    
    func refreshData() {        
        let tempActions = goal.actions?.allObjects as! [Action]
        actions = tempActions.sort { Int($0.0.priority!) > Int($0.1.priority!) }
        
        tableView.reloadData()
    }

}

extension ActionsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        actionName = textField.text
    }
}