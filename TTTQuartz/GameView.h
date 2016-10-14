//
//  GameView.h
//  TTTQuartz
//
//  Created by Kent Miller on 10/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

typedef enum  {
    WaitingForInput,
    WaitingForComputer,
    GameOver,
}
RenderState;

typedef enum {
    WinnerNone,
    WinnerCat,
    WinnerRow0,
    WinnerRow1,
    WinnerRow2,
    WinnerCol0,
    WinnerCol1,
    WinnerCol2,
    WinnerD1,
    WinnerD2
} Winner;

@interface GameView : UIView
{
    float xmin, ymin, xmax, ymax;
    float w, h;
    float x1, x2, y1, y2;
}

@property Game *game;
@property UIFont *font;
@property NSDictionary *xAttribs;
@property NSDictionary *oAttribs;
@property RenderState renderState;
@property CGRect OldRect;
@end
