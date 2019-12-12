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
    //NSLog(@"======LWLogger Log: %s",__func__);

}

- (IBAction)logSend:(id)sender {
    NSString *logZipPath = [LWLogUtil logZipPath];
    [self shareWithFilePath:logZipPath];
}

- (void)shareWithFilePath:(NSString *)filePath {
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSArray *objectsToShare = @[url];
    NSArray *excludedActivities = @[UIActivityTypeMessage, UIActivityTypeMail];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    controller.excludedActivityTypes = excludedActivities;
//     Present the controller
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
}

@end
