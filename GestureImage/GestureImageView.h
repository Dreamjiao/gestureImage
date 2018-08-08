//
//  GestureImageView.h
//  GestureZoomAndPan
//
//  Created by achellies on 14-8-26.
//  Copyright (c) 2014年 Paul Solt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface GestureImageView : UIImageView

@property (nonatomic, assign) Boolean transOrigin;
@property (nonatomic, assign) int reversial;

@property (nonatomic, assign) double minZoom;
@property (nonatomic, assign) double maxZoom;
@property (nonatomic, assign) double zoomSpeed;

@property (nonatomic, strong) UIImageView* imageview;

@end
