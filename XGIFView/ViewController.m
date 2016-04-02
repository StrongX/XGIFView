//
//  ViewController.m
//  XGIFView
//
//  Created by xlx on 16/3/31.
//  Copyright © 2016年 xlx. All rights reserved.
//

#import "ViewController.h"
#import "XGIFView.h"


#define DemoURL @"http://image.nihaowang.com/news/2015-04-27/c30f866d-9300-4f6e-86f6-58f408630e14.gif"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    XGIFView *gifView = [[XGIFView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    gifView.gifImageWithLocalName = @"gifDemo";
//    gifView.gifNetWorkURL = DemoURL;
    gifView.center = self.view.center;
    [self.view addSubview:gifView];
    
    
}
- (IBAction)clearCache:(id)sender {
    [XGIFView clearCache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
