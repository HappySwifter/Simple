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

    var goal: Goal!

    override func viewDidLoad() {
        super.viewDidLoad()
        Model.instanse.insertAction(goal, name: "Взять и сделать", priority: 0)
        
        let actions = Model.instanse.getActions()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

