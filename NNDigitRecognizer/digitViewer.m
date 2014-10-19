//
//  digitViewer.m
//  NeuralDigit
//
//  Created by yasu on 2014/10/17.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "digitViewer.h"

@interface digitViewer()
{
    NSMutableArray *array;
    double **M;
    CGPoint loc;
    BOOL writeFlag;
    CGFloat DOTSIZE;
}
@end

@implementation digitViewer

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        array = [NSMutableArray array];
        for (int i=0;i<27;i++) {
            for (int j=0;j<27;j++) {
                UIView *dot = [[UIView alloc] init];
                [array addObject:dot];
                [self addSubview:dot];
                dot.tag = 0;
                dot.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    return self;
}

- (void)setDOTS:(CGFloat)DOTS
{
    if (_DOTS == DOTS) return;
    _DOTS = DOTS;
    DOTSIZE = self.frame.size.width / self.DOTS;
    [self reset];
    for (UIView *view in array) {
        view.alpha = 0.0;
    }
    for (int i=0;i<self.DOTS;i++) {
        for (int j=0;j<self.DOTS;j++) {
            UIView *dot = [array objectAtIndex:i*self.DOTS+j];
            dot.alpha = 1.0f;
            dot.frame = CGRectMake(DOTSIZE*j, DOTSIZE*i, DOTSIZE-0.5, DOTSIZE-0.5);
        }
    }
}

- (void)reset
{
    for (UIView *dot in array) {
        dot.tag = 0;
        dot.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setBits:(NSArray *)bits
{
    for (int i=0;i<bits.count;i++) {
        UIView *dot = [array objectAtIndex:i];
        if ([[bits objectAtIndex:i] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            dot.tag = 0;
            dot.backgroundColor = [UIColor whiteColor];
        } else {
            dot.tag = 1;
            dot.backgroundColor = [UIColor blackColor];
        }
    }
}

- (NSArray *)getBits
{
    NSMutableArray *bitsArray = [NSMutableArray array];
    for (UIView *dot in array) {
        [bitsArray addObject:[NSNumber numberWithInteger:dot.tag]];
    }
    return bitsArray;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    int row, col;
    row = location.y/DOTSIZE;
    col = location.x/DOTSIZE;
    if (row < 0 || row >= self.DOTS || col < 0 || col >= self.DOTS) return;
 
    UIView *dot = [array objectAtIndex:row*self.DOTS+col];
    dot.backgroundColor = [UIColor blackColor];
    dot.tag = 1;
    loc = location;
    writeFlag = true;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    int row, col;

    if (!writeFlag&!(location.x < 0 || location.x >= DOTSIZE * self.DOTS || location.y < 0 || location.y >= DOTSIZE * self.DOTS)) {
        writeFlag = true;
        loc = location;
    }
    CGPoint diff = CGPointMake(location.x-loc.x, location.y-loc.y);
    
    if (!writeFlag) return;
    for (int i=0;i<10;i++) {
        row = (location.y - diff.y/10 * i)/DOTSIZE;
        col = (location.x - diff.x/10 * i)/DOTSIZE;
        if (row < 0 || row >= self.DOTS || col < 0 || col >= self.DOTS) continue;
        
        UIView *dot = [array objectAtIndex:row*self.DOTS+col];
        dot.backgroundColor = [UIColor blackColor];
        dot.tag = 1;
    }
    loc = location;
    
    if (location.x < 0 || location.x >= DOTSIZE * self.DOTS || location.y < 0 || location.y >= DOTSIZE * self.DOTS) {
        writeFlag = false;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
