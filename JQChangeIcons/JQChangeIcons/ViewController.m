//
//  ViewController.m
//  JQChangeIcons
//
//  Created by 韩俊强 on 2017/3/30.
//  Copyright © 2017年 HaRi. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self runtimeReplaceAlert];
}

// 利用runtime来替换展现弹出框的方法
- (void)runtimeReplaceAlert
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(ox_presentViewController:animated:completion:));
        // 交换方法实现
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
}

// 自己的替换展示弹出框的方法
- (void)ox_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        NSLog(@"title : %@",((UIAlertController *)viewControllerToPresent).title);
        NSLog(@"message : %@",((UIAlertController *)viewControllerToPresent).message);
        
        // 换图标时的提示框的title和message都是nil，由此可特殊处理
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) { // 是换图标的提示
            return;
        } else {// 其他提示还是正常处理
            [self ox_presentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    
    [self ox_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (IBAction)changeAppIconAction:(UIButton *)sender
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
