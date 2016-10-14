//
//  Game.m
//  TTT
//
//  Created by Kent Miller on 10/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "Game.h"

@implementation Game

-(Game*) init
{
    if (self = [super init])
    {
        self.board = malloc(sizeof(SpaceState) * 9);
        for (int i = 0; i < 9; i++)
        {
            self.board[i] = SpaceEmpty;
        }
    }
    return self;
}

-(void) resetGame
{
    for (int i = 0; i < 9; i++)
    {
        self.board[i] = SpaceEmpty;
    }
}

-(BOOL) canPlay
{
    for (int i = 0; i < 9; i++)
    {
        if (self.board[i] == SpaceEmpty)
            return YES;
    }
    return NO;
}



void MakeBoardScore(BoardScore *bs, SpaceState *board, SpaceState player)
{
    bs->row0 = (board[0] == player) + (board[1] == player) + (board[2] == player);
    bs->row1 = (board[3] == player) + (board[4] == player) + (board[5] == player);
    bs->row2 = (board[6] == player) + (board[7] == player) + (board[8] == player);
    bs->col0 = (board[0] == player) + (board[3] == player) + (board[6] == player);
    bs->col1 = (board[1] == player) + (board[4] == player) + (board[7] == player);
    bs->col2 = (board[2] == player) + (board[5] == player) + (board[8] == player);
    bs->d1   = (board[0] == player) + (board[4] == player) + (board[8] == player);
    bs->d2   = (board[2] == player) + (board[4] == player) + (board[6] == player);
}

-(void) MakeBoardScoresForX:(BoardScore *)x O:(BoardScore *)o 
{
    MakeBoardScore(x, self.board, SpaceX);
    MakeBoardScore(o, self.board, SpaceO);
}

void Play(SpaceState* board, SpaceState player)
{
    SpaceState otherPlayer = ((player == SpaceX) ? SpaceO : SpaceX);

    BoardScore myBS;
    BoardScore oppBS;

    MakeBoardScore(&myBS,  board, player);
    MakeBoardScore(&oppBS, board, otherPlayer);

    for (int i=0; i < 9; i++)
    {
        if (board[i] != SpaceEmpty)
            continue;
        //Can I win?
        switch (i)
        {
            case 0: if ((myBS.row0 == 2) || (myBS.col0 == 2) || (myBS.d1 == 2)) {board[i] = player; return;} break;
            case 1: if ((myBS.row0 == 2) || (myBS.col1 == 2))                   {board[i] = player; return;} break;
            case 2: if ((myBS.row0 == 2) || (myBS.col2 == 2) || (myBS.d2 == 2)) {board[i] = player; return;} break;
            case 3: if ((myBS.row1 == 2) || (myBS.col0 == 2))                   {board[i] = player; return;} break;
            case 4: if ((myBS.row1 == 2) || (myBS.col1 == 2) || (myBS.d1 == 2) || (myBS.d2 == 2)) {board[i] = player; return;} break;
            case 5: if ((myBS.row1 == 2) || (myBS.col2 == 2))                   {board[i] = player; return;} break;
            case 6: if ((myBS.row2 == 2) || (myBS.col0 == 2) || (myBS.d2 == 2)) {board[i] = player; return;} break;
            case 7: if ((myBS.row2 == 2) || (myBS.col1 == 2))                   {board[i] = player; return;} break;
            case 8: if ((myBS.row2 == 2) || (myBS.col2 == 2) || (myBS.d1 == 2)) {board[i] = player; return;} break;
        }
    }
    for (int i=0; i < 9; i++)
    {
        if (board[i] != SpaceEmpty)
            continue;
        //should I block?
        switch (i)
        {
            case 0: if ((oppBS.row0 == 2) || (oppBS.col0 == 2) || (oppBS.d1 == 2)) {board[i] = player; return;} break;
            case 1: if ((oppBS.row0 == 2) || (oppBS.col1 == 2))                    {board[i] = player; return;} break;
            case 2: if ((oppBS.row0 == 2) || (oppBS.col2 == 2) || (oppBS.d2 == 2)) {board[i] = player; return;} break;
            case 3: if ((oppBS.row1 == 2) || (oppBS.col0 == 2))                    {board[i] = player; return;} break;
            case 4: if ((oppBS.row1 == 2) || (oppBS.col1 == 2) || (oppBS.d1 == 2) || (oppBS.d2 == 2)) {board[i] = player; return;} break;
            case 5: if ((oppBS.row1 == 2) || (oppBS.col2 == 2))                    {board[i] = player; return;} break;
            case 6: if ((oppBS.row2 == 2) || (oppBS.col0 == 2) || (oppBS.d2 == 2)) {board[i] = player; return;} break;
            case 7: if ((oppBS.row2 == 2) || (oppBS.col1 == 2))                    {board[i] = player; return;} break;
            case 8: if ((oppBS.row2 == 2) || (oppBS.col2 == 2) || (oppBS.d1 == 2)) {board[i] = player; return;} break;
        }
    }

    //can't win or don't have to block, so pick somewhere to play
    if (board[4] == SpaceEmpty) board[4] = player;  //center is best
    else if (board[0] == SpaceEmpty) board[0] = player;  //corners next
    else if (board[2] == SpaceEmpty) board[2] = player;
    else if (board[6] == SpaceEmpty) board[6] = player;
    else if (board[8] == SpaceEmpty) board[8] = player;
    else if (board[1] == SpaceEmpty) board[1] = player;  //sides
    else if (board[3] == SpaceEmpty) board[3] = player;
    else if (board[4] == SpaceEmpty) board[5] = player;
    else if (board[7] == SpaceEmpty) board[7] = player;
}

-(void) autoPlay:(SpaceState) player
{
    Play(self.board, player);
}

-(BOOL) play:(SpaceState) player square:(int) square
{
    if (self.board[square] == SpaceEmpty)
    {
        self.board[square] = player;
        return YES;
    }
    return NO;
}
@end
