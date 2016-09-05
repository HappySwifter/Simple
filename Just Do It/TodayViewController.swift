//
//  TodayViewController.swift
//  Just Do It
//
//  Created by Артем Валиев on 26.08.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import UIKit
import NotificationCenter
import Simple

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Привет Привет Привет Привет Привет"
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Model.instanse.goalWithName("")

        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.NewData)
    }
    
}
