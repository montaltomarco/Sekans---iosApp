//
//  PlayAreaView.swift
//  Sekans
//
//  Created by Marco Montalto on 12/14/15.
//  Copyright © 2015 Marco Montalto. All rights reserved.
//

import UIKit

class PlayAreaView : UIView
{
    var controller           : PlayAreaViewController?;
    
    // PlayingArea
    let offsetXRight         : Int = 4;
    let offsetXLeft          : Int = 5;
    let offsetY              : Int = 7;
    let lineWidth            : Int = 3;
    var playingAreaWidth     : Int = 360
    var playingAreaHeight    : Int = 480
    var originX              : Int = 8
    var originY              : Int = 74
    
    // Snake Size
    var snakeSize            : Int = 15 // 15 is the default size, big is 20
    
    // Default Grid
    var NumColumns           : Int = 24 //18 if big
    var NumRows              : Int = 32 //24 if big
    var gameGrid = Array<Array<Bool>>()
    
    // Snakes
    var snakeNb              : Int = 2;
    var snakes = Array<Snake>()
    var playerName           : String = "Player1";
    
    // Initial positions
    var posColorsDirections = [(0,0,UIColor.cyanColor(), 0)];
    
    // Speed
    var delay : NSTimeInterval = 0.5
    
    // The retained layer
    var drawLayer            : CGLayerRef? = nil
    
    // Must be retained for start and stop
    var timer                : NSTimer? = nil
    
    var isPlaying            : Bool = true;
    var useTransparency      : Bool = false;
    
    // Colors
    let black = UIColor.blackColor()
    
    /*
        drawRect(rect: CGRect) : get/create the layer and draw on it
 
    */
    override func drawRect(rect: CGRect)
    {
        // Get the context being draw upon
        let context = UIGraphicsGetCurrentContext()
        
        if (drawLayer == nil)
        {
            // Create the layer if we don't have one
            let size = CGSizeMake(self.bounds.size.width, self.bounds.size.height)
            drawLayer = CGLayerCreateWithContext(context, size, nil)
            initGame();
        }
        
        // Draw to the layer
        self.drawSnakeToLayer()
        
        // Copy layer to context
        CGContextDrawLayerInRect (context, self.bounds, drawLayer);
    }
    
    func initGame() {
        
        posColorsDirections.removeAll();
        posColorsDirections = [ (0,0,UIColor.cyanColor(), 0), (playingAreaWidth-snakeSize, playingAreaHeight-snakeSize, UIColor.redColor(), 1), (playingAreaWidth-snakeSize, 0, UIColor.orangeColor(), 2), (0, playingAreaHeight-snakeSize, UIColor.yellowColor(), 3) ];
        
        isPlaying = true;
        delay = 0.5;
        drawPlayArea();
        gameGrid.removeAll();
        snakes.removeAll();
        
        gameGrid = [[Bool]](count: NumColumns, repeatedValue:[Bool](count: NumRows, repeatedValue:Bool(false)));
        
        snakes.append(Snake(color: posColorsDirections[0].2, positionX: posColorsDirections[0].0, positionY: posColorsDirections[0].1, direction: posColorsDirections[0].3, isPlayer: true, snakeSize: snakeSize));
        snakes[0].name = playerName
        
        for var i = 1; i < snakeNb; i++ {
            snakes.append(Snake(color: posColorsDirections[i].2, positionX: posColorsDirections[i].0, positionY: posColorsDirections[i].1, direction: posColorsDirections[i].3, isPlayer: false, snakeSize: snakeSize));
            switch (posColorsDirections[i].0, posColorsDirections[i].1) {
            case (0,0):
                gameGrid[0][0] = true;
                
            case (playingAreaWidth-snakeSize, playingAreaHeight-snakeSize):
                gameGrid[NumColumns-1][NumRows-1] = true;
                snakes[i].gridPositionX = NumColumns-1;
                snakes[i].gridPositionY = NumRows-1;
                
            case (playingAreaWidth-snakeSize,0):
                gameGrid[NumColumns-1][0] = true;
                snakes[i].gridPositionX = NumColumns-1;
                snakes[i].gridPositionY = 0;
                
            case (0, playingAreaHeight-snakeSize):
                
                gameGrid[0][NumRows-1] = true;
                
                snakes[i].gridPositionX = 0;
                snakes[i].gridPositionY = NumRows-1;
            default :
                break;
            }
        }
    }
    
    func drawPlayArea() {
        let leftLine = CGRect(x: offsetXLeft, y: 64 + offsetY, width: lineWidth, height: 486);
        
        let rightLine = CGRect(x:Int(bounds.size.width - CGFloat(offsetXRight)) - lineWidth, y:64 + offsetY, width: lineWidth, height: 486);
        
        let upLine = CGRect(x: offsetXLeft + lineWidth, y: 64 + offsetY, width: 360, height: lineWidth);
        
        let DownLine = CGRect(x: offsetXLeft + lineWidth, y: Int(bounds.size.height - CGFloat(offsetY)) - 103 - lineWidth, width: 360, height: lineWidth);
        
        drawRectangleUsing(leftLine, withColor: black)
        drawRectangleUsing(rightLine, withColor: black)
        drawRectangleUsing(upLine, withColor: black)
        drawRectangleUsing(DownLine, withColor: black)
    }
    
    /*
        drawSnakeToLayer() -> prepare the rectangles to be drawn
    
    */
    func drawSnakeToLayer()
    {
        var play : Bool = true;
        for snake in snakes {
            let blackX = snake.positionX
            let blackY = snake.positionY
            let blackRect = CGRect(x: originX + blackX, y: originY + blackY, width:snakeSize, height:snakeSize)
            
            let snakePos = snake.move(snakeSize);
            let snakeHead = CGRect(x: originX + snakePos.0, y: originY + snakePos.1, width:snakeSize, height:snakeSize)
            
            // Do the drawing
            if (snake.round > 0) {
                drawRectangleUsing(snakeHead, withColor:snake.color)
            }
            if (snake.round > 1) {
                drawRectangleUsing(blackRect, withColor:UIColor.blackColor())
                if (play) {
                    play = checkAndUpdateGrid(snake.gridPositionX, gridY: snake.gridPositionY);
                    if (!play) {
                        drawRectangleUsing(snakeHead, withColor:UIColor.brownColor());
                        snake.lost = true;
                    }
                }else{
                    checkAndUpdateGrid(snake.gridPositionX, gridY: snake.gridPositionY);
                }
            }
        }
        
        if(!play) {
            stopDrawing();
            isPlaying = false;
            self.controller!.gameOver();
            stopDrawing();
        }
    }
    
    func checkAndUpdateGrid(gridX: Int, gridY: Int) -> Bool {
        if(gridX>=0 && gridY>=0 && gridX<NumColumns && gridY<NumRows && !gameGrid[gridX][gridY]) {
            gameGrid[gridX][gridY] = true;
            return true;
        }else{
            return false;
        }
    }
    
    /*
        drawRectangleUsing(theRect : CGRect, withColor color : UIColor) ->
        draws the rectagle 'theRect', using the color 'color'
    
    */
    func drawRectangleUsing(theRect : CGRect, withColor color : UIColor)
    {
        if(color != UIColor.blackColor() && color != UIColor.brownColor()){
            let roundRect = UIBezierPath(roundedRect: theRect, byRoundingCorners:.AllCorners, cornerRadii: CGSizeMake(4, 4))
        
            color.setFill();
            roundRect.fill();
            
        }else{
            // Get layer context
            let layer_context = CGLayerGetContext (drawLayer)
        
            // Get color components, note the & for the inout parameter
            var red   : CGFloat = 0.0
            var green : CGFloat = 0.0
            var blue  : CGFloat = 0.0
            var alpha : CGFloat = 0.0
            color.getRed(&red, green:&green, blue:&blue, alpha:&alpha)
        
            // Set colors, stroke not used if fill (could do both)
            CGContextSetRGBFillColor(layer_context, red, green, blue, alpha)
            CGContextSetRGBStrokeColor(layer_context, red, green, blue, alpha)
        
            // Draw the rectangle
            CGContextAddRect(layer_context, theRect)
            CGContextDrawPath(layer_context, .Fill)
        }
    }
    
    /*
        startDrawing() -> called by the controller to start drawing
    
    */
    func startDrawing()
    {
        // Set timer, Target/Action pattern used here
        timer = NSTimer(timeInterval: delay,
            target: self,
            selector: Selector("setNeedsDisplay"),
            userInfo: nil,
            repeats: true)
        
        // Get the runloop, add timer to runloop
        let runLoop = NSRunLoop.currentRunLoop()
        runLoop.addTimer(timer!, forMode: "NSDefaultRunLoopMode")
    }
    
    /*
        stopDrawing() -> called by the controller to stop drawing
    
    */
    func stopDrawing()
    {
        // Clear timer
        if let timer2 = timer
        {
            timer2.invalidate()
        }
        self.timer = nil
    }
    
    func setContr(controller : PlayAreaViewController) {
        self.controller = controller;
    }
    
    func restart() {
        drawLayer = nil;
    }
    
    func changeNameAndDimension(playerName: String, snakeDim: String) {
        self.playerName = playerName;
        switch snakeDim {
            case "Small":
                snakeSize = 10
                NumColumns = 36
                NumRows = 48
            case "Normal":
                snakeSize = 15
                NumColumns = 24
                NumRows = 32
            case "Big":
                snakeSize = 20
                NumColumns = 18
                NumRows = 24
            default:
                snakeSize = 15
                NumColumns = 24
                NumRows = 32
        }
    }
}

