//
//  ConfigViewController.swift
//  Sekans
//
//  Created by Marco Montalto on 12/14/15.
//  Copyright © 2015 Marco Montalto. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var gameOverLabel: UILabel!
    
    var gameOverMessage : String = "";
    var gameController : PlayAreaViewController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverLabel.text = gameOverMessage;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func restartButtonHandler(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        gameController!.restartGame(false);
    }
    
    @IBAction func scoresButtonHandler(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        gameController!.openScores();
    }
}



