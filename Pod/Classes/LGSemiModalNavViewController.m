//
//  LGSemiModalNavViewController.h
//  6th Man Apps LLC
//
//  Created by Luke Geiger on 7/13/15.
//  Copyright (c) 2016 6th Man Apps LLC. All rights reserved.
//

#import "LGSemiModalNavViewController.h"

@interface LGSemiModalNavViewController ()

@end

@implementation LGSemiModalNavViewController

#pragma mark - Life

- (void)loadView{
    [super loadView];
    
    self.navigationBarHidden = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.view.clipsToBounds = YES;
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    [self defaults];
}

-(void)defaults{
    _tapDismissEnabled = YES;
    _animationSpeed = 0.35f;
    _backgroundShadeColor = [UIColor blackColor];
    _scaleTransform = CGAffineTransformMakeScale(.94, .94);
    _springDamping = 0.88;
    _springVelocity = 14;
    _backgroundShadeAlpha = 0.4;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.dismissalDelegate semiModalWillDismiss];
}

#pragma mark - Actions

- (void)dismissWasTapped{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Handle rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.view.frame = self.newFrameBlock(size, self.view.frame);
        
        CGRect backgroundFrame = CGRectMake(0, 0, size.width, size.height);
        backgroundFrame.size.height -= self.bottomMargin;
        self.backgroundView.frame = backgroundFrame;
        
        self.recognizerView.frame = CGRectMake(0, 0, size.width, size.height);
    } completion:nil];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [self transitionPresenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self transitionPresenting:NO];
}

-(LGSemiModalTransition*)transitionPresenting:(BOOL)presenting{
    LGSemiModalTransition *animator = [LGSemiModalTransition new];
    animator.viewController = self;
    animator.presenting = presenting;
    animator.tapDismissEnabled = _tapDismissEnabled;
    animator.animationSpeed = _animationSpeed;
    animator.backgroundShadeColor = _backgroundShadeColor;
    animator.scaleTransform = _scaleTransform;
    animator.springDamping = _springDamping;
    animator.springVelocity = _springVelocity;
    animator.backgroundShadeAlpha = _backgroundShadeAlpha;
    animator.leftMargin = _leftMargin;
    animator.bottomMargin = _bottomMargin;
    return animator;
}

@end
