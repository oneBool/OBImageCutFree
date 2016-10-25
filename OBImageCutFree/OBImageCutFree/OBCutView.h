//
//  OBCutView.h
//  OBImageCutFree
//
//  Created by oneBool on 2016/10/24.
//  Copyright © 2016年 oneBool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBCutView : UIView

@property (nonatomic , strong) UIBezierPath *path;
@property (nonatomic , strong) UIColor *strokeColor;
@property (nonatomic , assign) CGFloat linewidth;
@end
