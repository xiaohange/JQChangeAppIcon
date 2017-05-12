# JQChangeAppIcon
[ iOS中 iOS10.3如何更换 app 图标 (教程)](http://blog.csdn.net/qq_31810357/article/details/68489138
)

### iOS中 iOS10.3如何更换 app 图标  利用runtime后台切换icon
#### 效果如下：
![](http://img.blog.csdn.net/20170330162610437)

#### info.plist 如何填写呢？一时可能搞不清楚如何操作，下面做个实例:
```
<key>CFBundleIcons</key>
    <dict>
        <key>CFBundleAlternateIcons</key>
        <dict>
            <key>newIcon</key>
            <dict>
                <key>CFBundleIconFiles</key>
                <array>
                    <string>newIcon</string>
                </array>
                <key>UIPrerenderedIcon</key>
                <false/>
            </dict>
        </dict>
        <key>CFBundlePrimaryIcon</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>Icon60X60</string>
            </array>
        </dict>
    </dict> 
```

#### 替换图标部分的代码：
```
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
```
### 遇到一个问题：必须弹框吗？
#### A：NO！
#### 优化：利用runtime后台切换icon
```
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

```
### 优化后的效果如下：
![](http://img.blog.csdn.net/20170512104703077?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcXFfMzE4MTAzNTc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

## Other
[JQTumblrHud-高仿Tumblr App 加载指示器hud](https://github.com/xiaohange/JQTumblrHud)

[JQScrollNumberLabel：仿tumblr热度滚动数字条数](https://github.com/xiaohange/JQScrollNumberLabel)

[TumblrLikeAnimView-仿Tumblr点赞动画效果](https://github.com/xiaohange/TumblrLikeAnimView)

[JQMenuPopView-仿Tumblr弹出视图发音频、视频、图片、文字的视图](https://github.com/xiaohange/JQMenuPopView)

## Star
>iOS开发者交流群：446310206 喜欢就❤️❤️❤️star一下吧！你的支持是我更新的动力！ Love is every every every star! Your support is my renewed motivation!

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE). 