//
//  Snake.swift
//  Sekans
//
//  Created by Marco Montalto on 12/14/15.
//  Copyright © 2015 Marco Montalto. All rights reserved.
//

import UIKit

class Snake {
    
    /* DIRECTIONS
    * 0 : down
    * 1 : up
    * 2 : left
    * 3 : right
    */
    
    var positionX : Int = 0;
    var positionY : Int = 0;
    var gridPositionX : Int = 0;
    var gridPositionY : Int = 0;
    var color = UIColor.blackColor();
    var direction : Int = 0;
    var isPlayer : Bool = false;
    var name : String = "";
    var round : Int = -1;
    var lost : Bool = false;
    var snakeSize : Int = 0;
    
    init(color: UIColor, positionX: Int, positionY: Int, direction: Int, isPlayer : Bool, snakeSize: Int) {
        self.color = color;
        self.positionX = positionX;
        self.positionY = positionY;
        self.snakeSize = snakeSize;
        switch (positionX,positionY) {
            case (0,0):
                gridPositionX = 0;
                gridPositionY = 0;
            case (360-snakeSize, 480-snakeSize):
                name = "Computer1"
            case (360-snakeSize,0):
                name = "Computer2"
            case (0, 480-snakeSize):
                name = "Computer3"
            default :
                break;
        }
        self.direction = direction;
        self.isPlayer = isPlayer;
    }
    
    func move(snakeSize : Int) -> (Int, Int) {
        if (self.round > 0) {
            switch self.direction {
                case 0 : //down
                    self.positionY = positionY + snakeSize;
                    self.gridPositionY = gridPositionY + 1;
                case 1 : //up
                    self.positionY = positionY - snakeSize;
                    self.gridPositionY = gridPositionY - 1;
                    if (name == "Computer1" && self.round == 5) {
                        self.direction = 2;
                    }else if(name == "Computer1" && self.round == 20) {
                        self.direction = 2;
                    }
                case 2 : //left
                    self.positionX = positionX - snakeSize;
                    self.gridPositionX = gridPositionX - 1;
                    if (name == "Computer1" && self.round == 9) {
                        self.direction = 1;
                    }
                    if (name == "Computer1" && self.round == 25) {
                        self.direction = 0;
                }
                case 3 : //right
                    self.positionX = positionX + snakeSize;
                    self.gridPositionX = gridPositionX + 1;
                default :
                    break;
            }
            round++;
        } else {
            round++;
        }
        return (positionX, positionY)
    }

}
