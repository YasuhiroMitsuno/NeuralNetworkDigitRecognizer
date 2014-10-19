//
//  Recognizer.h
//  NeuralDigit
//
//  Created by yasu on 2014/10/19.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recognizer : NSObject

- (void)initialize;
- (void)train;
- (NSArray *)test:(NSArray *)bits;

@end
