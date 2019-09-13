//
//  DemoFlutterViewController.m
//  Runner
//
//  Created by JianFei Wang on 2019/9/10.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "DemoFlutterViewController.h"

@interface DemoFlutterViewController ()

@end

@implementation DemoFlutterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"go_back_button"] style:UIBarButtonItemStyleDone target:self action:@selector(popOrClose)];
}

@end
