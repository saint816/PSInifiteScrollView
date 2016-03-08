//
//  ViewController.m
//  03-0使用UIScrollView制作无限滚动
//
//  Created by 彭圣 on 16/3/5.
//  Copyright © 2016年 PS. All rights reserved.
//

#import "ViewController.h"
#import "PSInifiteScrollView.h"
#import "TestView.h"

@interface ViewController ()<PSInifiteScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TestView *scrollView = [[TestView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    scrollView.images = @[
                          [NSURL URLWithString:@"http://img1.bdstatic.com/static/home/widget/search_box_home/logo/home_white_logo_0ddf152.png"],
                          [UIImage imageNamed:@"img_00"],
                          @"img_01",
                          [UIImage imageNamed:@"img_02"],
                          [UIImage imageNamed:@"img_04"]
                          ];
    scrollView.delegate = self;
    scrollView.interval = 2.0;
    scrollView.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    scrollView.pageControl.backgroundColor = [UIColor clearColor];
    

    scrollView.scrollDirection = PSInifiteScrollDirectionHorizontal;
   


    
    [self.view addSubview:scrollView];
}

#pragma mark - PSInifiteScrollViewDelegate

- (void)inifiteScrollView:(PSInifiteScrollView *)inifiteScrollView didClickImageAtIndex:(NSInteger)imageIndex
{
    NSLog(@"点击的是第:%zd张图片",imageIndex);
}

@end
