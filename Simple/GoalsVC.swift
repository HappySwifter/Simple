//
//  MasterViewController.swift
//  Simple
//
//  Created by Артем Валиев on 29.06.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import UIKit
import CoreData
import HPReorderTableView

class GoalsVC: UITableViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var goalName: String?
    var activeGoals = [Goal]()
    var archievedGoals = [Goal]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        activeGoals.removeAll()
        archievedGoals.removeAll()
    }

    func insertNewObject(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Новая Цель", message: "", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Название"
            textField.delegate = self
        }
        let action = UIAlertAction(title: "OK", style: .Default) { [weak self] (action) in
            guard let sSelf = self where sSelf.goalName?.characters.count > 0 else { return }
            if let goalName = sSelf.goalName {
                Model.instanse.saveNewGoal(goalName)
                sSelf.refreshData()
            }

        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func insertNewArchivedGoal() {
    
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeGoals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GoalCell", forIndexPath: indexPath)
        cell.textLabel?.text = activeGoals[indexPath.row].name
        let actionSet = activeGoals[indexPath.row].actions
        let firstAction = (actionSet?.allObjects as! [Action]).sort { Int($0.0.priority!) > Int($0.1.priority!) }.first
        cell.detailTextLabel?.text = firstAction?.name

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let goal = activeGoals[indexPath.row]
            goal.deleteGoal()
            refreshData()
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowActionsSegue", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowActionsSegue" {
            if let contr = segue.destinationViewController as? ActionsVC {
                if let indexPath = sender as? NSIndexPath {
                     contr.goal = activeGoals[indexPath.item]
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func configureCell(cell: UITableViewCell, withObject object: Goal) {
        cell.textLabel!.text = object.name
    }

  
    func refreshData() {
        let allGoals = Model.instanse.getGoals()
        activeGoals = allGoals.filter { Bool($0.archieved!) == false }
        archievedGoals = allGoals.filter { Bool($0.archieved!) == true }
        tableView.reloadData()
    }

}


extension GoalsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
         goalName = textField.text
    }
}
