//
//  ViewController.m
//  JQChangeIcons
//
//  Created by 韩俊强 on 2017/3/30.
//  Copyright © 2017年 HaRi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)changeAppIconAction:(UIButton *)sender
{
    [self changeAppIcon];
}

- (void)changeAppIcon
{
    if ([UIApplication sharedApplication].supportsAlternateIcons) {
        NSLog(@"you can change this app's icon");
    }else{
        NSLog(@"you can not change this app's icon");
        return;
    }
    
    NSString *iconName = [[UIApplication sharedApplication] alternateIconName];
    
    if (iconName) {
        // change to primary icon
        [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"set icon error: %@",error);
            }
            NSLog(@"The alternate icon's name is %@",iconName);
        }];
    }else{
        // change to alterante icon
        [[UIApplication sharedApplication] setAlternateIconName:@"newIcon" completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"set icon error: %@",error);
            }
            NSLog(@"The alternate icon's name is %@",iconName);
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
