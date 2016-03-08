//
//  PSInifiteScrollView.h
//  03-0使用UIScrollView制作无限滚动
//
//  Created by 彭圣 on 16/3/5.
//  Copyright © 2016年 PS. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 代理 */
@class PSInifiteScrollView;

@protocol PSInifiteScrollViewDelegate <NSObject>
@optional
/** 用来传给外界被点击的图片的索引 */
- (void)inifiteScrollView:(PSInifiteScrollView *)inifiteScrollView didClickImageAtIndex:(NSInteger)imageIndex;
@end

/** 滚动方向控制的枚举 */
typedef NS_ENUM(NSInteger,PSInifiteScrollDirection){
    PSInifiteScrollDirectionHorizontal = 0,
    PSInifiteScrollDirectionVertical
};

@interface PSInifiteScrollView : UIView
/** 图片数据(里面可以存放UIImage对象、NSString对象【本地图片名】、NSURL对象【远程图片的URL】) */
@property (nonatomic,strong) NSArray *images;

/** 占位图片 */
@property (nonatomic,strong) UIImage *placeholder;

/** 播放的时间间隔,默认值是1.5秒 */
@property (nonatomic,assign) NSTimeInterval interval;

/** pagecontrol,提供接口以方便设置其属性 */
@property (nonatomic,weak,readonly) UIPageControl *pageControl;

/** 控制滚动方向 */
@property (nonatomic,assign) PSInifiteScrollDirection scrollDirection;

/** 代理属性 */
@property (nonatomic,weak) id<PSInifiteScrollViewDelegate> delegate;
@end
