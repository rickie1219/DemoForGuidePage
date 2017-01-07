//
//  IntroductionViewController.h
//  DemoForGuidePage
//
//  Created by Rickie_Lambert on 2017/1/5.
//  Copyright © 2017年 Excise. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义选中进入首页的按钮block
typedef void(^DidSelectedEnter)();

@interface IntroductionViewController : UIViewController

/**
 *  引导页滚动视图
 */
@property (nonatomic, strong) UIScrollView *pagingScrollView;

/**
 *  进入首页的按钮
 */
@property (nonatomic, strong) UIButton *btnEnter;

/**
 *  进入首页按钮的block
 */
@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

/**
 *  背景图片数组
 */
@property (nonatomic, strong) NSArray *arrBgImageNames;

/**
 *  封面图片数组
 */
@property (nonatomic, strong) NSArray *arrCoverImageNames;

#pragma mark 只有封面的初始化方法
- (instancetype)initWithCoverImageNames:(NSArray *)coverNames;

#pragma mark 封面和背景图片的初始化方法
- (instancetype)initWithCoverImageNames:(NSArray *)coverNames backgroudImageNames:(NSArray *)bgNames;

#pragma mark 有封面/背景图片,以及进入按钮的初始化方法
- (instancetype)initWithCoverImageNames:(NSArray *)coverNames backgroudImageNames:(NSArray *)bgNames btnEnter:(UIButton *)button;

@end
