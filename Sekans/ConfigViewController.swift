//
//  ConfigViewController.swift
//  Sekans
//
//  Created by Marco Montalto on 12/14/15.
//  Copyright © 2015 Marco Montalto. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    
    @IBOutlet weak var settingsBar: UITabBarItem!
    
    @IBOutlet weak var speedSlider: UISlider!
    
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var snakeDimensionControl: UISegmentedControl!
    @IBOutlet weak var enemiesControl: UISegmentedControl!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    var playAreaVC : PlayAreaViewController? = nil
    var playerName : String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController0 = navigationController!.viewControllers[0]
        playAreaVC = viewController0 as? PlayAreaViewController
        initValues();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initValues() {
        textFieldName.text = playerName;
        /*//Delay
        delaySlider.value = Float(delay)
        delayLabel.text = "Delay : " + (NSString(format: "%.1f", delay) as String);
        
        //Width
        widthMinLabel.text = "Width Min : " + (NSString(format: "%.1f", widthMin) as String);
        widthMinSlider.value = Float(widthMin)
        widthMaxLabel.text = "Width Max : " + (NSString(format: "%.1f", widthMax) as String);
        widthMaxSlider.value = Float(widthMax)
        
        //Height
        heightMinLabel.text = "Height Min : " + (NSString(format: "%.1f", heightMin) as String);
        heightMinSlider.value = Float(heightMin)
        heightMaxLabel.text = "Height Max : " + (NSString(format: "%.1f", heightMax) as String);
        heightMaxSlider.value = Float(heightMax)
        
        //Transparency
        transparencySwitch.on = useTransparency*/
        
    }
    
    
    @IBAction func speedChangeHandler(sender: AnyObject) {

        speedLabel.text = "Speed : " + (NSString(format: "%.1f", speedSlider.value) as String);
    }
    
    @IBAction func restartGameHandler(sender: AnyObject) {
        
        let playerName = textFieldName.text;
        let speed = speedSlider.value
        let snakeDim = snakeDimensionControl.titleForSegmentAtIndex(snakeDimensionControl.selectedSegmentIndex)
        let enemiesNb = enemiesControl.selectedSegmentIndex;
        
        navigationController?.popViewControllerAnimated(true)
        
        playAreaVC!.changeSettingsAndRestart(playerName!, speed: speed, snakeDim: snakeDim!, enemiesNb: enemiesNb);
        
    }
}
    

