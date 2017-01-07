//
//  AppDelegate.m
//  DemoForGuidePage
//
//  Created by Rickie_Lambert on 2017/1/5.
//  Copyright © 2017年 Excise. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "IntroductionViewController.h"

@interface AppDelegate ()
{
    NSArray *coverImageNames;
    NSArray *backgroundImageNames;
}

@property (nonatomic, strong) IntroductionViewController *introductionView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 添加window的根控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [_window makeKeyAndVisible];
    
    // 添加引导页视图
    // Added Introduction View Controller
    // 添加引导页,首先判断应用是否是第一次运行, 设置一个key作为app第二次运行时判断的标准
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 设置用户启用的时候的状态, 记录用户已经第一次启用过App
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [self createGuidePage];
    }
    // 如果是第一次以后登录,就直接跳过if运行后面的语句
    // do something else...
    return YES;
}

#pragma mark 创建引导页
- (void)createGuidePage
{
    coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
    backgroundImageNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
    
    // 方式一:只有背景图片或者封面
    [self methodOne];
    // 方式二:有封面, 也有背景图片
//    [self methodTwo];
    // 方式三:有封面,有背景图片,有按钮
//    [self methodThree];
    
    // 在window视图上添加 引导页的视图
    [self.window addSubview:self.introductionView.view];
    
    __weak AppDelegate *weakSelf = self;
    self.introductionView.didSelectedEnter = ^() {
        weakSelf.introductionView = nil;
    };
}

- (void)methodOne
{
    self.introductionView = [[IntroductionViewController alloc] initWithCoverImageNames:backgroundImageNames];
}

- (void)methodTwo
{
    self.introductionView = [[IntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroudImageNames:backgroundImageNames];
}

- (void)methodThree
{
    UIButton *btnEnter = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置按钮的参数, 背景颜色, 标题等等
    [btnEnter setBackgroundImage:[UIImage imageNamed:@"bg_mycenter_topbar"] forState:UIControlStateNormal];
    self.introductionView = [[IntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroudImageNames:backgroundImageNames btnEnter:btnEnter];
    // 可以修改进入按钮的位置, 自行设置(如果不设置,默认是IntroVC里面的frame设置
//    btnEnter.frame = CGRectMake((self.introductionView.view.frame.size.width - 200) / 2, self.introductionView.view.frame.size.height - 300, 200, 40);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
