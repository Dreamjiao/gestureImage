//
//  ViewController.m
//  GestureImage
//
//  Created by dadousmart on 2018/8/8.
//  Copyright © 2018年 Jackjiao. All rights reserved.
//

#import "ViewController.h"
#import "GestureImageView.h"

@interface ViewController ()
{
    __weak IBOutlet GestureImageView *_imageview;
    NSInteger _reversial;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//在修改锚点的情况下,不改变view的位置
-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

//反转镜像
- (IBAction)transAction:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:_imageview];
        
        if(_reversial == 0){
            _reversial = 1;
            _imageview.reversial = 1;
            
            _imageview.transform = CGAffineTransformScale(_imageview.transform, -1.0, 1.0);
        }else{
            _reversial = 0;
            _imageview.reversial = 0;
            
            _imageview.transform = CGAffineTransformScale(_imageview.transform, -1.0, 1.0);
        }
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
