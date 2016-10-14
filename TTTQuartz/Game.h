//
//  Game.h
//  TTT
//
//  Created by Kent Miller on 10/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SpaceEmpty = 0,
    SpaceX,
    SpaceO
} SpaceState;

typedef struct BoardScore {
    int row0;
    int row1;
    int row2;
    int col0;
    int col1;
    int col2;
    int d1;
    int d2;
} BoardScore;

@interface Game : NSObject

@property SpaceState *board;

-(void) MakeBoardScoresForX:(BoardScore *)x O:(BoardScore *)o;

-(void) resetGame;
-(void) autoPlay:(SpaceState) player;
-(BOOL) play:(SpaceState) player square:(int) square;
@end
