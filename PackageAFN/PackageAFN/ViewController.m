//
//  ViewController.m
//  PackageAFN
//
//  Created by YTKJ on 2019/5/6.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import "ViewController.h"
#import "NetAPIManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view, typically from a nib.
    [self getPhoneCode];
}


-(void)getPhoneCode {
    NSString *phoneStr = @"13621626715";
    [NetAPIManager getPhoneCode:phoneStr block:^(NSString * _Nonnull result, NSError * _Nonnull error) {
        
        if (!error) {
            NSLog(@"%@",result);
        }
        
    }];
   
}


@end
