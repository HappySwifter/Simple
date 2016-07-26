//
//  DetailViewController.swift
//  Simple
//
//  Created by Артем Валиев on 29.06.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import UIKit
import HPReorderTableView

class ActionsVC: UIViewController {

    enum ViewState: Int {
        case active = 0
        case all
    }
    @IBOutlet weak var tableView: HPReorderAndSwipeToDeleteTableView!
    @IBOutlet weak var newActionTextField: UITextField!

    var actionName: String?
    var goal: Goal!
    var actions = [Action]()
    let viewSwitcher = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = goal.name
        self.tableView.keyboardDismissMode = .OnDrag
        
        viewSwitcher.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        viewSwitcher.addTarget(self, action: #selector(changeView), forControlEvents: .ValueChanged)
        viewSwitcher.insertSegmentWithTitle("Active", atIndex: 0, animated: false)
        viewSwitcher.insertSegmentWithTitle("All", atIndex: 1, animated: false)
        viewSwitcher.selectedSegmentIndex = 0
        let barItem = UIBarButtonItem(customView: viewSwitcher)
        self.navigationItem.rightBarButtonItems = [barItem]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        goal = nil
        actions.removeAll()
        // Dispose of any resources that can be recreated.
    }

    func changeView(switcher: UISegmentedControl) {
        refreshData()
    }
    
    func getViewState() -> ViewState {
        return ViewState(rawValue: viewSwitcher.selectedSegmentIndex)!
    }
    
    @IBAction func checkBoxTapped(sender: CheckBox) {
        let indexPath = indexPathForView(sender)
        let action = actions[indexPath.row]
        action.togleDone()
        refreshData()
    }
    
    func indexPathForView(view: UIView) -> NSIndexPath {
        let viewOrigin = view.bounds.origin
        let viewLocation = tableView.convertPoint(viewOrigin, fromView: view)
        return tableView.indexPathForRowAtPoint(viewLocation)!
    }
    
    func refreshData() {
        let tempActions = goal.actions?.allObjects as! [Action]
        switch getViewState() {
        case .active:
            actions = tempActions.sort { Int($0.0.priority!) > Int($0.1.priority!) }.filter { $0.done!.boolValue == false }
        case .all:
            actions = tempActions.sort { Int($0.0.priority!) > Int($0.1.priority!) }
        }
        tableView.reloadData()
    }

}

extension ActionsVC {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ActionCell), forIndexPath: indexPath) as! ActionCell

        let action = actions[indexPath.row]
        cell.configure(withAction: action, indexPath: indexPath, shouldShowCheckBox: getViewState() == .all)
        cell.nameTextField.delegate = self
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let action = actions[indexPath.row]
            action.deleteAction()
            refreshData()
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        guard sourceIndexPath != destinationIndexPath else {
            refreshData()
            return
        }
        swap(&actions[sourceIndexPath.row], &actions[destinationIndexPath.row])
        for (index, action) in actions.reverse().enumerate() {
            action.priority = index
        }
        Model.instanse.saveContext()
        refreshData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if getViewState() == .active {
            return true
        } else {
            return false
        }
    }
    
    //TOD implement header with newActionTextField
    
}

extension ActionsVC: UITextFieldDelegate {




    
    func textFieldDidBeginEditing(textField: UITextField) {
//        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {

        guard let text = textField.text where text.characters.count > 0 else { return }
        if textField == newActionTextField {
            Model.instanse.insertAction(goal, name: text)
            refreshData()
            textField.text = ""
        } else {
            let indexPath = indexPathForView(textField)
            let action = actions[indexPath.row]
            action.name = textField.text
            Model.instanse.saveContext()
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // The 'add item' row can always dismiss the keyboard.
        if textField == newActionTextField {
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