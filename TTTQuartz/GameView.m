//
//  GameView.m
//  TTTQuartz
//
//  Created by Kent Miller on 10/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "GameView.h"

@implementation GameView

-(void) DrawLetter:(CGRect) box  player:(SpaceState) player
{
    if (self.font == nil)
    {
        self.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:100.0];
        NSMutableParagraphStyle *st = [[NSMutableParagraphStyle alloc] init];
        st.alignment = NSTextAlignmentCenter;
        self.xAttribs = @{ NSFontAttributeName : self.font, NSForegroundColorAttributeName : [UIColor blueColor], NSParagraphStyleAttributeName : st};
        self.oAttribs = @{ NSFontAttributeName : self.font, NSForegroundColorAttributeName : [UIColor redColor], NSParagraphStyleAttributeName : st };

    }

    if (player == SpaceX)
    {
        [@"X" drawInRect:box withAttributes:self.xAttribs];
    }
    else if (player == SpaceO)
    {
        [@"O" drawInRect:box withAttributes:self.oAttribs];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.game == nil)
    {
        self.game        = [[Game alloc] init];
        self.renderState = WaitingForInput;
        self.OldRect     = CGRectZero;
    }

    if (!CGRectEqualToRect(self.OldRect, rect))
    {
        xmin = rect.origin.x + 10.0;
        ymin = rect.origin.y + 10.0;
        xmax = xmin + rect.size.width - 20.0;
        ymax = ymin + rect.size.height - 20.0;
        w = xmax - xmin;
        h = ymax - ymin;
        x1 = xmin + (w/3.0);
        x2 = xmin + w - (w/3.0);
        y1 = ymin + (h/3.0);
        y2 = ymin + h - (h/3.0);
    }

    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blackColor] CGColor]));
    CGContextSetLineWidth(ctx, 5.0);

    CGContextMoveToPoint(ctx, x1, ymin);
    CGContextAddLineToPoint(ctx, x1, ymax);
    CGContextMoveToPoint(ctx, x2, ymin);
    CGContextAddLineToPoint(ctx, x2, ymax);

    CGContextMoveToPoint(ctx, xmin, y1);
    CGContextAddLineToPoint(ctx, xmax, y1);
    CGContextMoveToPoint(ctx, xmin, y2);
    CGContextAddLineToPoint(ctx, xmax, y2);

    CGContextStrokePath(ctx);

    CGContextSaveGState(ctx);

    float hpad = ((y1 - ymin) /2.0) - 50.0;
    float boxw = (x1 - xmin);
    float boxh = (y1 - ymin) - (hpad);

    {
        CGRect r = CGRectMake(xmin, ymin + hpad, boxw, boxh);
        [self DrawLetter:r player:self.game.board[0]];
    }
    {
        CGRect r = CGRectMake(x1, ymin + hpad, boxw, boxh);
        [self DrawLetter:r player:self.game.board[1]];
    }
    {
        CGRect r = CGRectMake(x2, ymin + hpad, boxw, boxh);
        [self DrawLetter:r player:self.game.board[2]];
    }

    {
        CGRect r = CGRectMake(xmin, y1 + hpad, boxw, boxh);
        [self DrawLetter:r player:self.game.board[3]];
    }
    {
        CGRect r = CGRectMake(x1, y1 + hpad, boxw, boxh);
        [self DrawLetter:r player:self.game.board[4]];
    }
    {
        CGRect r = CGRectMake(x2, y1 + hpad, boxw, boxh);
        [self DrawLetter:r player:self.game.board[5]];
    }

    {
        CGRect r = CGRectMake(xmin, y2 + hpad, boxw, boxh);
        [self DrawLetter:r player:self.game.board[6]];
    }
    {
        CGRect r = CGRectMake(x1, y2 + hpad, boxw, boxh);
        [self DrawLetter:r player:self.game.board[7]];
    }
    {
        CGRect r = CGRectMake(x2, y2 + hpad, boxw, boxh);
        [self DrawLetter:r player:self.game.board[8]];
    }
    CGContextRestoreGState(ctx);

    Winner wn = [self CheckWinner];
    if (wn > WinnerCat)
    {
        float xs, xf, ys, yf;
        float xh = (x1 - xmin) / 2.0;
        float yh = (y1 - ymin) / 2.0;
        float xq = xh / 2.0;
        float yq = yh / 2.0;
        switch (wn)
        {
            case WinnerRow0: xs = xmin + xq; xf = xmax - xq; ys = ymin + yh; yf = ys; break;
            case WinnerRow1: xs = xmin + xq; xf = xmax - xq; ys = y1   + yh; yf = ys; break;
            case WinnerRow2: xs = xmin + xq; xf = xmax - xq; ys = y2   + yh; yf = ys; break;
            case WinnerCol0: xs = xmin + xh; xf = xs; ys = ymin + yq; yf = ymax - yq; break;
            case WinnerCol1: xs = x1   + xh; xf = xs; ys = ymin + yq; yf = ymax - yq; break;
            case WinnerCol2: xs = x2   + xh; xf = xs; ys = ymin + yq; yf = ymax - yq; break;
            case WinnerD1:   xs = xmin + xq; xf = xmax - xq; ys = ymin + yq; yf = ymax - yq; break;
            case WinnerD2:   xs = xmax - xq; xf = xmin + xq; ys = ymin + yq; yf = ymax - yq; break;
            case WinnerCat:
            case WinnerNone: break;
        }

        CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blackColor] CGColor]));
        CGContextSetLineWidth(ctx, 5.0);
        CGContextMoveToPoint(ctx, xs, ys);
        CGContextAddLineToPoint(ctx, xf, yf);
        CGContextStrokePath(ctx);
    }
    else if (wn == WinnerCat)
    {
        CGRect r = CGRectMake(x1 + 2.0, y1 + 2.0, boxw - 4.0, 30.0);
        UIFont *font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:24.0];
        NSMutableParagraphStyle *st = [[NSMutableParagraphStyle alloc] init];
        st.alignment = NSTextAlignmentCenter;
        [@"Cat" drawInRect:r withAttributes:
         @{ NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor blackColor], NSParagraphStyleAttributeName : st}
         ];
    }
}


-(Winner) CheckWinner
{
    BoardScore x = {};
    BoardScore o = {};

    Winner wn = WinnerNone;

    [self.game MakeBoardScoresForX:&x O:&o];
    if (x.col0 == 3) wn = WinnerCol0;
    else if (x.col1 == 3) wn =  WinnerCol1;
    else if (x.col2 == 3) wn =  WinnerCol2;
    else if (x.row0 == 3) wn =  WinnerRow0;
    else if (x.row1 == 3) wn =  WinnerRow1;
    else if (x.row2 == 3) wn =  WinnerRow2;
    else if (x.d1 == 3) wn =  WinnerD1;
    else if (x.d2 == 3) wn =  WinnerD2;
    else if (o.col0 == 3) wn =  WinnerCol0;
    else if (o.col1 == 3) wn =  WinnerCol1;
    else if (o.col2 == 3) wn =  WinnerCol2;
    else if (o.row0 == 3) wn =  WinnerRow0;
    else if (o.row1 == 3) wn =  WinnerRow1;
    else if (o.row2 == 3) wn =  WinnerRow2;
    else if (o.d1 == 3) wn =  WinnerD1;
    else if (o.d2 == 3) wn =  WinnerD2;

    if (wn == WinnerNone)
    {
        //can anyone play?
        wn = WinnerCat;
        for (int i = 0; i < 9; i++)
        {
            if (self.game.board[i] == SpaceEmpty)
                wn = WinnerNone;
        }
    }

    if (wn != WinnerNone)
        self.renderState = GameOver;
    return wn;
}

-(void) ComputerPlay:(id) sender
{
    [self.game autoPlay:SpaceO];
    [self setNeedsDisplay];
    self.renderState = WaitingForInput;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = [touch tapCount];
    if ((tapCount > 0)  && (self.renderState == WaitingForInput))
    {
        CGPoint p = [touch locationInView:self];
        int touchInSquare = -1;
        if (p.y < y1)
        {
            if (p.x < x1 ) touchInSquare = 0;
            else if (p.x < x2) touchInSquare = 1;
            else touchInSquare = 2;
        }
        else if (p.y < y2)
        {
            if (p.x < x1 ) touchInSquare = 3;
            else if (p.x < x2) touchInSquare = 4;
            else touchInSquare = 5;
        }
        else
        {
            if (p.x < x1 ) touchInSquare = 6;
            else if (p.x < x2) touchInSquare = 7;
            else touchInSquare = 8;
       }
       if (touchInSquare != -1)
       {
           if ([self.game play:SpaceX square:touchInSquare])
           {
               self.renderState = WaitingForComputer;
               Winner wn = [self CheckWinner];
               if (wn == WinnerNone)
                   [self performSelector:@selector(ComputerPlay:) withObject:nil afterDelay:1.0];
               [self setNeedsDisplay];
           }
       }
    }
    else if (self.renderState == GameOver)
    {
        self.game = nil;
        [self setNeedsDisplay];
    }

}


@end
