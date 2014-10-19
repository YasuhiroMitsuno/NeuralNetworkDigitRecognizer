//
//  digitViewer.h
//  NeuralDigit
//
//  Created by yasu on 2014/10/17.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface digitViewer : UIView

- (void)setDots;
- (void)reset;
- (void)setBits:(NSArray *)bits;
- (NSArray *)getBits;

@end
