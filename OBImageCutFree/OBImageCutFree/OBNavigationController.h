//
//  OBNavigationController.h
//  OBImageCutFree
//
//  Created by oneBool on 2015/11/08.
//  Copyright © 2015年 oneBool. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define kkBackViewHeight [UIScreen mainScreen].bounds.size.height
#define kkBackViewWidth [UIScreen mainScreen].bounds.size.width

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define startX -200;


@interface OBNavigationController : UINavigationController
{
    CGFloat startBackViewX;
    BOOL firstTouch;
}

// 默认为特效开启,canDragBack需要默认为NO，否则会手势冲突
@property (nonatomic, assign) BOOL canDragBack;
@property (nonatomic, assign) BOOL specialPop;

-(void)addGestureRecognizer;
@end


