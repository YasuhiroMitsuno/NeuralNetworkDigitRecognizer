//
//  ViewController.m
//  NeuralDigit
//
//  Created by yasu on DOTSIZE14/10/17.
//  Copyright (c) DOTSIZE14年 yasu. All rights reserved.
//

#import "ViewController.h"
#import "digitViewer.h"
#import "Recognizer.h"
#import "resultViewer.h"

@interface ViewController ()
{
    digitViewer *viewer;
    resultViewer *rViewer;
    Recognizer *rec;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    viewer = [[digitViewer alloc] initWithFrame:CGRectMake(20, 100, 160, 160)];
    [self.view addSubview:viewer];
    [viewer setDots];
    rViewer = [[resultViewer alloc] initWithFrame:CGRectMake(0, 300, 360, 100)];
    rViewer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rViewer];
    rec = [[Recognizer alloc] init];
    [rec initialize];
    [rec train];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *resetbtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 20, 50, 50)];
    resetbtn.backgroundColor = [UIColor redColor];
    [resetbtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetbtn];
    
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
