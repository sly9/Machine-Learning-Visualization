//
//  KNNController.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/27/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <unistd.h>
#import "KNNController.h"
#import "KNN.h"
#import "MLDataPoint.h"
#import "KNNSideController.h"
#import "KNNView.h"

@implementation KNNController 
@synthesize sideController=_sideController;
@synthesize k=_k;
@synthesize knn=_knn;
@synthesize classifyStatus=classifyStatus;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _knn = [[KNN alloc] init];
        decisionBoundaryDrawn = NO;
        queue = [[NSOperationQueue alloc] init];
        lastTouchedPoint = nil;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self=[super initWithCoder:aDecoder]) {
        _knn = [[KNN alloc] init];
        decisionBoundaryDrawn = NO;
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) viewDidLoad {
    
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touch:)];
    gestureRecognizer.minimumPressDuration = 0;
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.delegate = self;
    knnView = (KNNView *) self.view;
    knnView.knn = _knn;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) deleteSelectedData
{
    [self Log:@"deleteSelectedData"];
}
-(void) removeAllData
{
    [self Log:@"removeAllData"];
}
-(void) drawDecisionBoundary{
    [self drawDecisionBoundaryWithSize:32];
}


-(void) drawDecisionBoundaryWithSize:(NSUInteger)size
{
    //dispatch_queue_t queue = dispatch_get_global_queue(                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    [queue cancelAllOperations];
    operationId = mach_absolute_time();
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self Log:@"drawDecisionBoundary"]; 
        decisionBoundaryDrawn=YES;
        uint64_t oId = operationId;
        NSArray *labels = [_knn decisionBoundaryForStep:size onViewSize:self.view.frame.size];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (operationId !=oId) {
                NSLog(@"operation cancelled!");
                return;
            }
            [knnView updateDecisionBoundaryWithLabels:labels andSize:size];
            if (size > 4) {
                NSUInteger newSize = size/2;
                [self drawDecisionBoundaryWithSize:newSize];
            }
            
        });
        
    }];
    [queue addOperation:operation]; 
//    
//    dispatch_async(queue, ^{
//        [self Log:@"drawDecisionBoundary"]; 
//        decisionBoundaryDrawn=YES;
//
//        NSArray *labels = [_knn decisionBoundaryForStep:size onViewSize:self.view.frame.size];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [knnView updateDecisionBoundaryWithLabels:labels andSize:size];
//            if (size > 2) {
//                NSUInteger newSize = size/2;
//                [self drawDecisionBoundaryWithSize:newSize];
//            }
//            
//        });
//        
//    });
}

-(void) Log:(NSString *)str{
    [self.sideController appendLog:str];
}

#pragma mark gesture recognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // If we're in ruler editing mode, don't let the paint gestures see a touch unless the ruler gesture has begun
    //    if (mRulerGR && mRulerGR.state == UIGestureRecognizerStatePossible) {
    //        return (gestureRecognizer == mRulerGR);
    //    }
    
    // If a touch goes down on the slider or buttons, we shouldn't paint with it
    return YES;
}
-(void) touch:(UIGestureRecognizer *)gr {
    if (classifyStatus) {
        [self classifyDataTouch:gr];        
    } else {
        [self addDataTouch:gr];
    }
}

-(void) addDataTouch:(UIGestureRecognizer *)gr
{
    CGPoint location  = [gr locationInView:self.view];
    //NSLog(@"touch ,%@",NSStringFromCGPoint(location));
    switch (gr.state) {
        case UIGestureRecognizerStatePossible: {
            //NSLog(@"a GR should never fire in state possible!");
            break;
        }
        case UIGestureRecognizerStateBegan: {   
            //add circle to model
            MLDataPoint *aPoint = [_knn nearestDataPointFromPoint:location];
            if (aPoint == nil) {
                MLDataPoint *newPoint = [[MLDataPoint alloc] initWithCGPoint:location andLabel:labelForNewData];
                [_knn addDataPoint:newPoint];
                
                lastTouchedPoint = newPoint;                
            } else {
                lastTouchedPoint = aPoint;
            }
            break;
        }   
        case UIGestureRecognizerStateChanged:
        { 
            MLDataPoint *to = [[MLDataPoint alloc] initWithCGPoint:location andLabel:lastTouchedPoint.label];
            [_knn moveDataPointFrom:lastTouchedPoint to:to];
            lastTouchedPoint = to;
            break;
        }
        case UIGestureRecognizerStateEnded:
        {   
            lastTouchedPoint = nil;
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            lastTouchedPoint = nil;
            break;
        }
    }
//    KNNView *knnView = (KNNView *)self.view;
    [knnView updateView];

    if (decisionBoundaryDrawn) {
        [self drawDecisionBoundary];
    }
    
}
-(void) classifyDataTouch:(UIGestureRecognizer *)gr
{
    switch (gr.state) {
        case UIGestureRecognizerStatePossible: {
            //NSLog(@"a GR should never fire in state possible!");
            break;
        }
        case UIGestureRecognizerStateBegan: {   
            //add circle to model
            break;
        }   
        case UIGestureRecognizerStateChanged:
        { 
            //[self Log:@"Classify a data"];
            //NSArray *nearestK = [_knn nearestKPoints:[gr locationInView:gr.view]];
            //NSLog(@"nearest k points: %@",nearestK);
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {   
            [self Log:@"Classify a data"];
            CGPoint location=[gr locationInView:gr.view];
            NSArray *nearestK = [_knn nearestKPoints:location];
            NSLog(@"nearest k points: %@",nearestK);
            [knnView drawDecisionForPoint:location withNeighbors:nearestK];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            break;
        }
    }

    
}



-(void) changeLabel:(NSUInteger)label{
    labelForNewData=label;
    [self
     Log:[NSString stringWithFormat:@"labelForNewData = %d",label]];
}

-(void) setK:(NSUInteger)k {
    _k = k;
    _knn.k = k;
    
    if (classifyStatus && decisionBoundaryDrawn) {
        [self drawDecisionBoundary];
    }
    
}
@end
