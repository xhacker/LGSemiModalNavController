//
//  LGSemiModalTransition.m
//  6th Man Apps LLC
//
//  Created by Luke Geiger on 7/13/15.
//  Copyright (c) 2016 6th Man Apps LLC. All rights reserved.
//

#import "LGSemiModalTransition.h"
#import "LGSemiModalNavViewController.h"

@interface LGSemiModalTransition ()

@end

@implementation LGSemiModalTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.animationSpeed;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toViewController = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect modalViewFinalFrame = CGRectMake(0, transitionContext.containerView.frame.size.height - toViewController.view.frame.size.height - self.bottomMargin, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
    CGRect modalViewInitialFrame = modalViewFinalFrame;
    modalViewInitialFrame.origin.y = transitionContext.containerView.frame.size.height - self.bottomMargin;
    modalViewInitialFrame.size.height = 0;
    
    UIView* backgroundView = [[[[transitionContext containerView] subviews] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag = 99"]] lastObject];
    if(!backgroundView){
        CGRect frame = transitionContext.containerView.bounds;
        frame.size.height -= self.bottomMargin;
        backgroundView = [[UIView alloc] initWithFrame:frame];
        backgroundView.alpha = 0;
        backgroundView.tag = 99;
        backgroundView.backgroundColor = _backgroundShadeColor;
    }

    UIView *recognizerView = [[[transitionContext containerView] subviews] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag = 233"]].lastObject;
    if (!recognizerView){
        recognizerView = [[UIView alloc] initWithFrame:transitionContext.containerView.bounds];
        recognizerView.tag = 233;
        
        if (self.tapDismissEnabled) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:toViewController action:@selector(dismissWasTapped)];
            [recognizerView addGestureRecognizer:tap];
        }
    }
    
    fromViewController.view.userInteractionEnabled = NO;
    toViewController.view.userInteractionEnabled = NO;
    
    if (self.presenting) {
        [transitionContext.containerView insertSubview:backgroundView belowSubview:toViewController.view];
        [transitionContext.containerView insertSubview:recognizerView aboveSubview:backgroundView];
        
        toViewController.view.frame = modalViewInitialFrame;
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect navBarFrame = ((LGSemiModalNavViewController*)toViewController).navigationBar.frame;
        ((LGSemiModalNavViewController*)toViewController).navigationBar.frame = CGRectMake(navBarFrame.origin.x, 0, navBarFrame.size.width, navBarFrame.size.height);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             backgroundView.alpha = _backgroundShadeAlpha;
                            [(UIView*)[transitionContext.containerView.subviews objectAtIndex:0] setTransform:_scaleTransform];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.frame = modalViewFinalFrame;
                         }
                         completion:^(BOOL finished) {
                             fromViewController.view.userInteractionEnabled = YES;
                             toViewController.view.userInteractionEnabled = YES;
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             [(UIView*)[transitionContext.containerView.subviews objectAtIndex:0] setTransform:CGAffineTransformMakeScale(1, 1)];
                             fromViewController.view.frame = modalViewInitialFrame;
                             backgroundView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             fromViewController.view.userInteractionEnabled = YES;
                             toViewController.view.userInteractionEnabled = YES;
                             toViewController.view.hidden = NO;
                             [transitionContext completeTransition:YES];
                         }];
    }
}

@end
