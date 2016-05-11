//
//  ScoresViewController.swift
//  Sekans
//
//  Created by Marco Montalto on 12/14/15.
//  Copyright © 2015 Marco Montalto. All rights reserved.
//

import UIKit

class ScoresViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var lostLabel: UILabel!
    
    var name : String = "Player1";
    var winNb : Int = 0;
    var lostNb : Int = 0;
    var gameController : PlayAreaViewController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initValues();
    }
    
    func initValues() {
        nameLabel.text = "Your Name : " + name;
        winLabel.text = "Win : " + String(winNb);
        lostLabel.text = "Lost : " + String(lostNb);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func resetButtonHandler(sender: AnyObject) {
        gameController?.winNb = 0;
        gameController?.lostNb = 0;
        winLabel.text = "Win : 0";
        lostLabel.text = "Lost : 0";
        
    }
    
}


