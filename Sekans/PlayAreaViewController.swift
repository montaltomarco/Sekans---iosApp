//
//  PlayAreaViewController.swift
//  Sekans
//
//  Created by Marco Montalto on 12/14/15.
//  Copyright © 2015 Marco Montalto. All rights reserved.
//

import UIKit

class PlayAreaViewController: UIViewController {
    
    var isDrawing = true;
    var gameOverMessage = "You Win!";

    let black = UIColor.blackColor()
    let defaultBlue = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var messagesLabel: UILabel!
    
    var settingsVC : ConfigViewController? = nil
    var gameOverVC : GameOverViewController? = nil
    var scoresVC : ScoresViewController? = nil
    
    var lostNb : Int = 0;
    var winNb : Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.multipleTouchEnabled = true
        
        upButton.layer.cornerRadius = 8.0
        downButton.layer.cornerRadius = 8.0
        leftButton.layer.cornerRadius = 8.0
        rightButton.layer.cornerRadius = 8.0
        
        let viewController1 = navigationController?.viewControllers[0]
        settingsVC = viewController1 as? ConfigViewController
    }
    
    override func viewDidAppear(animated: Bool)
    {
        let topView = self.view as! PlayAreaView
        if(topView.isPlaying) {
            topView.startDrawing()
            topView.setContr(self);
        }else{
            topView.stopDrawing()
            performSegueWithIdentifier("gameOverScreen", sender: self);
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        let topView = self.view as! PlayAreaView
        topView.stopDrawing()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait ,UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func upButtonHandler(sender: AnyObject) {
        let topView = self.view as! PlayAreaView
        topView.snakes[0].direction = 1;
        
        upButton.backgroundColor = black;
        setDefaultColors(false);
    }
    
    @IBAction func downButtonHandler(sender: AnyObject) {
        let topView = self.view as! PlayAreaView
        topView.snakes[0].direction = 0;
        
        downButton.backgroundColor = black;
        setDefaultColors(false);
    }
    
    @IBAction func leftButtonHandler(sender: AnyObject) {
        let topView = self.view as! PlayAreaView
        topView.snakes[0].direction = 2;
        
        leftButton.backgroundColor = black;
        setDefaultColors(true);
    }
    
    @IBAction func rightButtonHandler(sender: AnyObject) {
        let topView = self.view as! PlayAreaView
        topView.snakes[0].direction = 3;
        
        rightButton.backgroundColor = black;
        setDefaultColors(true);
    }
    
    func setDefaultColors(isUpDown : Bool) {
        if (isUpDown) {
            upButton.backgroundColor = defaultBlue;
            downButton.backgroundColor = defaultBlue;
            
            upButton.enabled = true;
            downButton.enabled = true;
            rightButton.enabled = false;
            leftButton.enabled = false;
        }else{
            rightButton.backgroundColor = defaultBlue;
            leftButton.backgroundColor = defaultBlue;
            
            rightButton.enabled = true;
            leftButton.enabled = true;
            upButton.enabled = false;
            downButton.enabled = false;
        }
    }
    
    @IBAction func scoresIconHandler(sender: AnyObject) {
        openScores();
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let topView = self.view as! PlayAreaView
        if(segue.identifier == "toSettingsScores") {
            let tabBarController = segue.destinationViewController as? UITabBarController
            let tabBarControllerArray = tabBarController!.viewControllers
            
            let viewController1 = tabBarControllerArray?[1]
            settingsVC = viewController1 as? ConfigViewController
            settingsVC!.playerName = topView.snakes[0].name;
            
            let viewControllerSc = tabBarControllerArray?[0]
            scoresVC = viewControllerSc as? ScoresViewController
            scoresVC!.name = topView.snakes[0].name;
            scoresVC!.lostNb = lostNb;
            scoresVC!.winNb = winNb;
            scoresVC!.gameController = self;
        }else{
            gameOverVC = segue.destinationViewController as? GameOverViewController
            gameOverVC!.gameOverMessage = gameOverMessage;
            gameOverVC!.gameController = self;
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let topView = self.view as! PlayAreaView
        
        if touches.count >= 2 && isDrawing {
            topView.stopDrawing()
            performSegueWithIdentifier("toSettingsScores", sender: self)
        } else if touches.count == 1 {
            
            /*if isDrawing {
                print(isDrawing);
                isDrawing = false;
                topView.stopDrawing()
                
            } else {
                print(isDrawing);
                isDrawing = true;
                if topView.isPlaying {
                    topView.startDrawing();
                }
            }*/
        }
    }
    
    func gameOver() {
        let topView = self.view as! PlayAreaView
        topView.stopDrawing();
        var win = true;
        gameOverMessage = "You Win!";
        for snake in topView.snakes {
            if (snake.lost && snake.isPlayer) {
                gameOverMessage = "You Lost!";
                lostNb = lostNb + 1
                win = false;
                break;
            }
        }
        
        if(win){
            winNb = winNb + 1
        }
        messagesLabel.text = "Game Over";
        performSegueWithIdentifier("gameOverScreen", sender: self)
    }
    
    func restartGame(isFromConfig: Bool) {
        print("Restarting");
        
        downButton.backgroundColor = black;
        setDefaultColors(false);
        
        let topView = self.view as! PlayAreaView
        topView.restart();
        
        if(!isFromConfig) {
            topView.startDrawing();
        }
        
        messagesLabel.text = "Let's go Blue Snake!"
    }
    
    func openScores() {
        print("Opeing Scores");
        performSegueWithIdentifier("toSettingsScores", sender: self)
    }
    
    func changeSettingsAndRestart(playerName: String, speed: Float, snakeDim: String, enemiesNb: Int) {
        let topView = self.view as! PlayAreaView
        topView.isPlaying = true;
        
        topView.snakeNb = enemiesNb + 2
        topView.delay = Double(speed);
        
        restartGame(true);
        
        messagesLabel.text = "Let's go Blue Snake!"
        topView.changeNameAndDimension(playerName, snakeDim: snakeDim);
    }
}

