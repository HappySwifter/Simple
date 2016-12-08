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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GoalsVC: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var goalName: String?
    var activeGoals = [Goal]()
    var archievedGoals = [Goal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        login()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        let registerButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(register))
        let loginButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(login))
        let syncButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(modelVersion))

        self.navigationItem.leftBarButtonItems = [registerButton, loginButton, syncButton]

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        activeGoals.removeAll()
        archievedGoals.removeAll()
    }

    func insertNewObject(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Новая Цель", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Название"
            textField.delegate = self
        }
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            guard let sSelf = self, sSelf.goalName?.characters.count > 0 else { return }
            if let goalName = sSelf.goalName {
                Networking.addGoal(withName: goalName, cb: { success in
                    sSelf.refreshData()
                })
                
            }

        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func register() {
        Networking.register()
    }
    
    func login() {
        Networking.login { (success) in
            if success {
                Networking.downloadAllData(completion: { [weak self] (success) in
                    self?.refreshData()
                })
            }
        }
    }
    
    func modelVersion() {
        Networking.modelVersion(cb: { [weak self] string in
            let alert = UIAlertController(title: "DB", message: string, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(closeAction)
            self?.present(alert, animated: true, completion: nil)
        })
    }
    
    func insertNewArchivedGoal() {
    
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeGoals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
        cell.textLabel?.text = activeGoals[indexPath.row].name
        let actionSet = activeGoals[indexPath.row].actions
        let firstAction = (actionSet?.allObjects as! [Action]).sorted { Int($0.0.priority!) > Int($0.1.priority!) }.first
        cell.detailTextLabel?.text = firstAction?.name

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let goal = activeGoals[indexPath.row]
            Networking.remove(goal: goal, cb: { [weak self] (done) in
                if done {
                    self?.refreshData()
                }
            })
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowActionsSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowActionsSegue" {
            if let contr = segue.destination as? ActionsVC {
                if let indexPath = sender as? IndexPath {
                     contr.goal = activeGoals[indexPath.item]
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func configureCell(_ cell: UITableViewCell, withObject object: Goal) {
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
    func textFieldDidEndEditing(_ textField: UITextField) {
         goalName = textField.text
    }
}
