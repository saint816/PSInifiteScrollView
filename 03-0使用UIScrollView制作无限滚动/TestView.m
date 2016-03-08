//
//  TestView.m
//  03-0使用UIScrollView制作无限滚动
//
//  Created by 彭圣 on 16/3/5.
//  Copyright © 2016年 PS. All rights reserved.
//

#import "TestView.h"

@implementation TestView
static NSInteger count = 0;
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, 165, 150, 35);
    count++;
    NSLog(@"子类---第%zd次调用layoutSubviews方法",count);
}

@end
