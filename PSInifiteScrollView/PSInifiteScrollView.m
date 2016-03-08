//
//  PSInifiteScrollView.m
//  03-0使用UIScrollView制作无限滚动
//
//  Created by 彭圣 on 16/3/5.
//  Copyright © 2016年 PS. All rights reserved.
//

#import "PSInifiteScrollView.h"
#import <UIImageView+WebCache.h>

@interface PSInifiteScrollView ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;

@property (nonatomic,weak) NSTimer * timer;
@end

@implementation PSInifiteScrollView

static NSInteger const PSImageViewCount = 3;
/** 添加子控件 */
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        //1,scrollView
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor greenColor];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //1.1imageViews in scrollView
        for (NSInteger i = 0; i < PSImageViewCount; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
            
            [self.scrollView addSubview:imageView];
        }
        
        //2,pageControl
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.backgroundColor = [UIColor blackColor];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        //默认设置图片播放间隔为1.5s
        self.interval = 1.5;
        //默认占位图片为text
        self.placeholder = [UIImage imageNamed:@"PSInifiteScrollView.bundle/placeholder"];
    }
    return self;
}

/** 布局子控件 */
static NSInteger count = 0;
- (void)layoutSubviews
{
    [super layoutSubviews];
    count++;
    NSLog(@"父类---第%zd次调用layoutSubviews方法",count);
    
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = self.frame.size.height;
    
    if (self.scrollDirection == PSInifiteScrollDirectionHorizontal) {
        self.scrollView.contentSize = CGSizeMake(PSImageViewCount * selfW, 0);
    }else{
        self.scrollView.contentSize = CGSizeMake(0, PSImageViewCount * selfH);
    }
    
    //1,scrollView
    self.scrollView.frame = self.bounds;
    
    //1.1imageViews in scrollView
    for (NSInteger i = 0; i < PSImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        if (self.scrollDirection == PSInifiteScrollDirectionHorizontal) {
            imageView.frame = CGRectMake(i * selfW, 0, selfW, selfH);
        }else{
            imageView.frame = CGRectMake(0, i * selfH, selfW, selfH);
        }
        
    }
    
    //2,pageControl
    CGFloat pageControlW = 100;
    CGFloat pageControlH = 25;
    self.pageControl.frame = CGRectMake(selfW - pageControlW, selfH - pageControlH, pageControlW, pageControlH);
    
    [self updateImageViewContentAndScrollViewOffset];
}

#pragma mark - 手势点击
- (void)imageClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(inifiteScrollView:didClickImageAtIndex:)])
    {
        [self.delegate inifiteScrollView:self didClickImageAtIndex:tap.view.tag];
    }
}

#pragma mark - 私有方法
/** 更新scrollView的子控件--imageView的内容和scrollView的偏移量 */
- (void)updateImageViewContentAndScrollViewOffset{

    //1.更新scrollView的子控件--imageView的内容
    
    for (NSInteger imageViewIndex = 0; imageViewIndex < PSImageViewCount; imageViewIndex++) {
        NSInteger imageIndex = 0;
        UIImageView *imageView = self.scrollView.subviews[imageViewIndex];
        
        if (imageViewIndex == 0) {
            imageIndex = self.pageControl.currentPage - 1;
            if (imageIndex == -1){
                imageIndex = self.images.count - 1;
            }
        }else if(imageViewIndex == 1){
            imageIndex = self.pageControl.currentPage;
        }else if(imageViewIndex == 2){
            imageIndex = self.pageControl.currentPage + 1;
            if (imageIndex == self.images.count) {
                imageIndex = 0;
            }
        }
        imageView.tag = imageIndex;
        id obj = self.images[imageIndex];
        if ([obj isKindOfClass:[UIImage class]]) {
            imageView.image = obj;
        }else if([obj isKindOfClass:[NSString class]]){
            imageView.image = [UIImage imageNamed:obj];
        }else if([obj isKindOfClass:[NSURL class]]){
            [imageView sd_setImageWithURL:obj placeholderImage:self.placeholder];
        }
        
        
    }
    
    //2.更新scrollView的偏移量
    
    if (self.scrollDirection == PSInifiteScrollDirectionHorizontal) {
       self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }else{
       self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }
    
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    self.pageControl.numberOfPages = images.count;
}

#pragma mark - 定时器方法
- (void)starTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage
{
    [UIView animateWithDuration:0.25 animations:^{
        if (self.scrollDirection == PSInifiteScrollDirectionHorizontal) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * 2, 0);
        }else{
            self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height * 2);
        }
        
        
    } completion:^(BOOL finished) {
        [self updateImageViewContentAndScrollViewOffset];
    }];
}

- (void)setInterval:(NSTimeInterval)interval
{
    _interval = interval;
    [self stopTimer];
    [self starTimer];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 找出显示在最中间的imageView
    UIImageView *middleImageView = nil;
    // x值和偏移量x的最小差值
    CGFloat minDelta = MAXFLOAT;
    for (NSInteger i = 0; i < PSImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        // x值和偏移量x差值最小的imageView，就是显示在最中间的imageView
        CGFloat currentDelta = 0;
        if (self.scrollDirection == PSInifiteScrollDirectionHorizontal) {
            currentDelta = ABS(imageView.frame.origin.x - self.scrollView.contentOffset.x);
        }else{
            currentDelta = ABS(imageView.frame.origin.y - self.scrollView.contentOffset.y);
        }
        if (currentDelta < minDelta) {
            minDelta = currentDelta;
            middleImageView = imageView;
        }
    }
    self.pageControl.currentPage = middleImageView.tag;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateImageViewContentAndScrollViewOffset];
}

/** 控制定时器的运行与停止 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self starTimer];
}

@end
