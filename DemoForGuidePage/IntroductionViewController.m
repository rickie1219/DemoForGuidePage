//
//  IntroductionViewController.m
//  DemoForGuidePage
//
//  Created by Rickie_Lambert on 2017/1/5.
//  Copyright © 2017年 Excise. All rights reserved.
//

#import "IntroductionViewController.h"

@interface IntroductionViewController ()<UIScrollViewDelegate>

// 背景视图
@property (nonatomic, strong) NSArray *backgroundViews;

@property (nonatomic, strong) NSArray *scrollViewPages;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger centerPageIndex;

@end

@implementation IntroductionViewController

- (void)dealloc
{
    self.view = nil;
}

#pragma mark 初始化方法
- (void)initSelfWithCoverNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    self.arrCoverImageNames = coverNames;
    self.arrBgImageNames = bgNames;
}

#pragma mark 只有封面的初始化方法
- (instancetype)initWithCoverImageNames:(NSArray *)coverNames
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:nil];
    }
    return self;
}

#pragma mark 封面和背景图片的初始化方法
- (instancetype)initWithCoverImageNames:(NSArray *)coverNames backgroudImageNames:(NSArray *)bgNames
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
    }
    return self;
}

#pragma mark 有封面/背景图片,以及进入按钮的初始化方法
- (instancetype)initWithCoverImageNames:(NSArray *)coverNames backgroudImageNames:(NSArray *)bgNames btnEnter:(UIButton *)button
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
        self.btnEnter = button;
    }
    return self;
}

#pragma mark 加载页面视图
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    // 添加背景视图
    [self addBackgroundViews];
    
    // 创建滚动视图
    self.pagingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.pagingScrollView.delegate = self;
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.pagingScrollView];
    
    // 创建页面指示器
    self.pageControl = [[UIPageControl alloc] initWithFrame:[self frameOfPageControl]];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:self.pageControl];
    
    // 如果没有进入按钮就创建进入首页按钮
    if (!self.btnEnter) {
        self.btnEnter = [UIButton new];
        [self.btnEnter setTitle:NSLocalizedString(@"Enter", nil) forState:UIControlStateNormal];
        self.btnEnter.layer.borderWidth = 0.5;
        self.btnEnter.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    // 进入按钮的点击事件
    [self.btnEnter addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
    self.btnEnter.frame = [self frameOfEnterButton];
    self.btnEnter.alpha = 0;
    [self.view addSubview:self.btnEnter];
    
    // 重新加载页面
    [self reloadPages];
    
}

#pragma mark 添加背景视图
- (void)addBackgroundViews
{
    CGRect frame = self.view.bounds;
    NSMutableArray *tempArray = [NSMutableArray new];
    [[[[self arrBgImageNames] reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        // 创建一个图片视图
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:obj]];
        imageView.frame = frame;
        imageView.tag = idx + 1;
        [tempArray addObject:imageView];
        [self.view addSubview:imageView];
    }];
    
    self.backgroundViews = [[tempArray reverseObjectEnumerator] allObjects];
}

#pragma mark 重新加载页面
- (void)reloadPages
{
    self.pageControl.numberOfPages = [[self arrCoverImageNames] count];
    self.pagingScrollView.contentSize = [self contentSizeOfScrollView];
    
    __block CGFloat x = 0;
    [[self scrollViewPages] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 设置view的frame
        obj.frame = CGRectOffset(obj.frame, x, 0);
        [self.pagingScrollView addSubview:obj];
        x += obj.frame.size.width;
    }];
    
    // fix enterButton can not presenting if ScrollView have only one page
    // 修复加入滚动视图只有一页的时候, 进入按钮不出现
    if (self.pageControl.numberOfPages == 1) {
        self.btnEnter.alpha = 1;
        self.pageControl.alpha = 0;
    }
    
    // fix ScrollView can not scrolling if it have only one page
    // 修复如果滚动视图只有一页的时候, 滚动视图不能滚动
    if (self.pagingScrollView.contentSize.width == self.pagingScrollView.frame.size.width) {
        self.pagingScrollView.contentSize = CGSizeMake(self.pagingScrollView.contentSize.width + 1, self.pagingScrollView.contentSize.height);
    }
}

#pragma mark 页面指示器的frame
- (CGRect)frameOfPageControl
{
    return CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 30);
}

#pragma mark 进入按钮的frame
- (CGRect)frameOfEnterButton
{
    CGSize size = self.btnEnter.bounds.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(self.view.frame.size.width * 0.6, 40);
    }
    return CGRectMake(self.view.frame.size.width / 2 - size.width / 2, self.pageControl.frame.origin.y - size.height, size.width, size.height);
}

#pragma mark =========== 代理协议 ===========
#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
    CGFloat alpha = 1 - ((scrollView.contentOffset.x - index * self.view.frame.size.width) / self.view.frame.size.width);
    
    if ([self.backgroundViews count] > index) {
        UIView *view = [self.backgroundViews objectAtIndex:index];
        if (view) {
            [view setAlpha:alpha];
        }
    }
    
    self.pageControl.currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / [self numberOfPagesInPagingScrollView]);
    
    [self pagingScrollViewDidChangePages:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        if (![self hasNext:self.pageControl]) {
            [self enter:nil];
        }
    }
}

#pragma mark =========== 数据源方法 ===========
#pragma mark - UIScrollView & UIPageControl DataSource
- (BOOL)hasNext:(UIPageControl *)pageControl
{
    return pageControl.numberOfPages > pageControl.currentPage + 1;
}

- (BOOL)isLast:(UIPageControl *)pageControl
{
    return pageControl.numberOfPages == pageControl.currentPage + 1;
}

- (NSInteger)numberOfPagesInPagingScrollView
{
    return [[self arrCoverImageNames] count];
}

- (void)pagingScrollViewDidChangePages:(UIScrollView *)pagingScrollView
{
    if ([self isLast:self.pageControl]) {
        if (self.pageControl.alpha == 1) {
            self.btnEnter.alpha = 0;
            // 用动画
            [UIView animateWithDuration:0.4 animations:^{
                self.btnEnter.alpha = 1;
                self.pageControl.alpha = 0;
            }];
        } else {
            if (self.pageControl.alpha == 0) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.btnEnter.alpha = 0;
                    self.pageControl.alpha = 1;
                }];
            }
        }
    }
}

#pragma mark 是否有进入按钮在视图中
- (BOOL)hasEnterButtonInView:(UIView *)page
{
    __block BOOL result = NO;
    [page.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && obj == self.btnEnter) {
            result = YES;
        }
    }];
    return result;
}

#pragma mark 配置scrollView
- (UIImageView *)scrollViewPage:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGSize size = {[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height};
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, size.width, size.height);
    return imageView;
}

#pragma mark 懒加载
- (NSArray *)scrollViewPages
{
    if ([self numberOfPagesInPagingScrollView] == 0) {
        return nil;
    }
    
    if (_scrollViewPages) {
        return _scrollViewPages;
    }
    
    NSMutableArray *tempArray = [NSMutableArray new];
    [self.arrCoverImageNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgView = [self scrollViewPage:obj];
        [tempArray addObject:imgView];
    }];
    
    _scrollViewPages = tempArray;
    return _scrollViewPages;
}

#pragma mark 
- (CGSize)contentSizeOfScrollView
{
    UIView *view = [[self scrollViewPages] firstObject];
    return CGSizeMake(view.frame.size.width * self.scrollViewPages.count, view.frame.size.height);
}

#pragma mark 
- (void)enter:(id)object
{
    if (self.didSelectedEnter) {
        self.didSelectedEnter();
    }
}



@end
