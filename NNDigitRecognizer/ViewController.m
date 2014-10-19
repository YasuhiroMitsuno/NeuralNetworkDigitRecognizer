//
//  ViewController.m
//  NeuralDigit
//
//  Created by yasu on DOTSIZE14/10/17.
//  Copyright (c) DOTSIZE14年 yasu. All rights reserved.
//

#import "ViewController.h"
#import "Recognizer.h"
#import "resultViewer.h"

@interface ViewController ()
{
    resultViewer *rViewer;
    Recognizer *rec;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    rViewer = [[resultViewer alloc] initWithFrame:CGRectMake(0, 300, 360, 100)];
    rViewer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rViewer];
    rec = [[Recognizer alloc] init];
    [rec initialize];
    [viewer setDOTS:7];
    // Do any additional setup after loading the view, typically from a nib.
    [recogButton addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
    [resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [trainButton addTarget:self action:@selector(startTrain) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(resize) forControlEvents:UIControlEventValueChanged];

}

- (void)resize
{
    NSInteger value;
    if (slider.value < 0.25) {
        value = 7;
        slider.value = 0;
    } else if (slider.value < 0.5) {
        value = 10;
        slider.value = 0.33;
    } else if(slider.value < 0.75) {
        value = 16;
        slider.value = 0.66;
    } else {
        value = 27;
        slider.value = 1.0;
    }
    [viewer setDOTS:value];
    
}

- (void)startTrain
{
    dispatch_queue_t sub_queue;
    sub_queue = dispatch_queue_create("train_thread", 0);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"学習中..." message:@"学習中..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    dispatch_async(sub_queue, ^{
        [rec train];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
    });
}

- (void)get {
    NSArray *array = [viewer getBits];
    NSString *str = [[NSString alloc] init];
    for (NSNumber *num in array) {
        str = [str stringByAppendingFormat:@"%@", num];
    }
    NSLog(@"%@", str);
    NSArray *result = [rec test:array];
    [rViewer set:result];
    
}

- (void)reset {
    [viewer reset];
    [rViewer reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
