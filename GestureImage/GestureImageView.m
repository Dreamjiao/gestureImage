//
//  GestureImageView.m
//  GestureZoomAndPan
//
//  Created by achellies on 14-8-26.
//  Copyright (c) 2014年 Paul Solt. All rights reserved.
//

#import "GestureImageView.h"

@interface GestureImageView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIGestureRecognizer *panGesture;
@property (nonatomic, strong) UIGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGesture;

@end

@implementation GestureImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initMovementGestures];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initMovementGestures];
}

-(void)removeFromSuperview
{
    [self removeGestureRecognizer:self.panGesture];
    [self removeGestureRecognizer:self.pinchGesture];
    [self removeGestureRecognizer:self.rotationGesture];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    NSLog(@"layoutSubviews");
}

#pragma mark - Private Methods

-(void)initMovementGestures
{
    self.userInteractionEnabled = YES;
    self.zoomSpeed = .5;
    self.minZoom = .5;
    self.maxZoom = 5;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    [self addGestureRecognizer:self.panGesture];
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    self.pinchGesture.delegate = self;
    [self addGestureRecognizer:self.pinchGesture];
    
    self.rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    self.rotationGesture.delegate = self;
    [self addGestureRecognizer:self.rotationGesture];
}

-(void)setTransOrigin:(Boolean)transOrigin
{
    if(transOrigin == false)
        return;
    
}

-(void)handlePanGesture:(UIPanGestureRecognizer *) panGesture
{
    if ([self.panGesture isEqual:panGesture]) {
        CGPoint translation = [panGesture translationInView:panGesture.view.superview];
        
        if (UIGestureRecognizerStateBegan == panGesture.state || UIGestureRecognizerStateChanged == panGesture.state) {
            panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x, panGesture.view.center.y + translation.y);
            [panGesture setTranslation:CGPointZero inView:panGesture.view.superview];
        }
    }
}

-(void)justPoint:(UIPinchGestureRecognizer *)pinchGesture
{
    //手势发生在哪个view上
    UIView *piece = pinchGesture.view;
    
    CGPoint onePoint = [pinchGesture locationOfTouch:0 inView:pinchGesture.view];
    CGPoint twoPoint = [pinchGesture locationOfTouch:1 inView:pinchGesture.view];
    
    CGPoint twoPointCenter = CGPointMake((onePoint.x + twoPoint.x)/2.0, (onePoint.y + twoPoint.y)/2.0);
    
    piece.layer.anchorPoint = CGPointMake(twoPointCenter.x / piece.bounds.size.width, twoPointCenter.y / piece.bounds.size.height);
    //根据在view上的位置设置锚点。
    //防止设置完锚点过后，view的位置发生变化，相当于把view的位置重新定位到原来的位置上。
    CGPoint locationInSuperview = [pinchGesture locationInView:piece.superview];
    
    piece.center = locationInSuperview;
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture
{
    if ([self.pinchGesture isEqual:pinchGesture]) {
        if (UIGestureRecognizerStateBegan == pinchGesture.state || UIGestureRecognizerStateChanged == pinchGesture.state) {
            NSInteger numberPoint = pinchGesture.numberOfTouches;
            
            //容错处理
            if(numberPoint != 2)
                return;
            
            [self justPoint:pinchGesture];
            
            float currentScale = pinchGesture.view.layer.contentsScale;
            float deltaScale = pinchGesture.scale;
            
            deltaScale = ((deltaScale - 1) * self.zoomSpeed) + 1;
            deltaScale = MIN(deltaScale, self.maxZoom / currentScale);
            deltaScale = MAX(deltaScale, self.minZoom / currentScale);
            
            CGAffineTransform zoomTransform = CGAffineTransformScale(pinchGesture.view.transform, deltaScale, deltaScale);
            pinchGesture.view.transform = zoomTransform;
            pinchGesture.scale = 1;
        }
    }
}

- (CGPoint)locationOfTouch:(NSUInteger)touchIndex inView:(nullable UIView*)view
{
    
    return CGPointZero;
}

-(void)handleRotateGesture:(UIRotationGestureRecognizer *)rotateGesture
{
    
    if ([self.rotationGesture isEqual:rotateGesture]) {
        if (UIGestureRecognizerStateBegan == rotateGesture.state || UIGestureRecognizerStateChanged == rotateGesture.state) {
            CGFloat rotate = rotateGesture.rotation;
            
            if(self.reversial == 1)
                rotate = -rotate;
            
            CGAffineTransform transform = CGAffineTransformRotate(rotateGesture.view.transform, rotate);
            rotateGesture.view.transform = transform;
            
            [rotateGesture setRotation:0];
        }
    }
}

-(void)justRotationPoint:(UIRotationGestureRecognizer *)pinchGesture
{
    //手势发生在哪个view上
    UIView *piece = pinchGesture.view;
    
    CGPoint onePoint = [pinchGesture locationOfTouch:0 inView:pinchGesture.view];
    CGPoint twoPoint = [pinchGesture locationOfTouch:1 inView:pinchGesture.view];
    
    CGPoint twoPointCenter = CGPointMake((onePoint.x + twoPoint.x)/2.0, (onePoint.y + twoPoint.y)/2.0);
    
    piece.layer.anchorPoint = CGPointMake(twoPointCenter.x / piece.bounds.size.width, twoPointCenter.y / piece.bounds.size.height);
    //根据在view上的位置设置锚点。
    //防止设置完锚点过后，view的位置发生变化，相当于把view的位置重新定位到原来的位置上。
    CGPoint locationInSuperview = [pinchGesture locationInView:piece.superview];
    piece.center = locationInSuperview;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return NO;
    }
    
    if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return NO;
    }
    
    return YES;
}
@end
