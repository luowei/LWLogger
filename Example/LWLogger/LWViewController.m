//
//  LWViewController.m
//  LWLogger
//
//  Created by luowei on 12/10/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import <LWLogger/LWLogger.h>
#import "LWViewController.h"

@interface LWViewController ()

@end

@implementation LWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    LWLog(@"======LWLogger Log: %s",__func__);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
