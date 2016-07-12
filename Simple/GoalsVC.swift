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
    var goals = [Goal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        goals.removeAll()
        // Dispose of any resources that can be recreated.
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

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GoalCell", forIndexPath: indexPath)
        cell.textLabel?.text = goals[indexPath.row].name
        let actionSet = goals[indexPath.row].actions
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
            let goal = goals[indexPath.row]
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
                     contr.goal = goals[indexPath.item]
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
        goals = Model.instanse.getGoals()
        tableView.reloadData()
    }

}


extension GoalsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
         goalName = textField.text
    }
}
