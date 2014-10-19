//
//  resultViewer.m
//  NeuralDigit
//
//  Created by yasu on 2014/10/19.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "resultViewer.h"

@interface resultViewer()
{
    NSMutableArray *plabels;
    NSMutableArray *dots;
}

@end

@implementation resultViewer

- (id)initWithFrame:(CGRect)frame
{
    plabels = [NSMutableArray array];
    dots = [NSMutableArray array];
    self = [super initWithFrame:frame];
    if (self) {
        for (int i=0;i<10;i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30*i+10, 10, 20, 12)];
            label.text = [NSString stringWithFormat:@"%d", i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectMake(30*i+5, 80, 30, 12)];
            plabel.text = @"0%";
            plabel.textAlignment = NSTextAlignmentCenter;
            plabel.font = [UIFont systemFontOfSize:8];
            
            UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(30 * i + 15, 25, 10, 0)];
            dot.backgroundColor = [UIColor blueColor];
            [self addSubview:dot];
            [self addSubview:label];
            [self addSubview:plabel];
            [plabels addObject:plabel];
            [dots addObject:dot];
        }
    }
    return self;
}

- (void)set:(NSArray *)result
{
    for (int i=0;i<10;i++) {
        UILabel *label = [plabels objectAtIndex:i];
        UIView *dot = [dots objectAtIndex:i];
        NSNumber *num = [result objectAtIndex:i];
        label.text = [NSString stringWithFormat:@"%.1lf%%", [num doubleValue] * 100];
        CGFloat height = [num doubleValue] * 50;
        dot.frame = CGRectMake(dot.frame.origin.x, 75 - height, dot.frame.size.width, height);
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
