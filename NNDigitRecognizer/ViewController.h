//
//  ViewController.h
//  NeuralDigit
//
//  Created by yasu on 2014/10/17.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "digitViewer.h"

@interface ViewController : UIViewController
{
    IBOutlet digitViewer *viewer;
    IBOutlet UIButton *recogButton;
    IBOutlet UIButton *resetButton;
    IBOutlet UIButton *trainButton;
    IBOutlet UISlider *slider;
}


@end

