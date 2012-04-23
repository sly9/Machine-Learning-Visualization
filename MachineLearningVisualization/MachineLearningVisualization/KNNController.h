//
//  KNNController.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/27/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNN;
@class KNNSideController;
@class KNNView;
@class MLDataPoint;
@interface KNNController : UIViewController<UIGestureRecognizerDelegate>{
    /*for adding new datas:*/
    NSUInteger labelForNewData;
    BOOL classifyStatus;
    KNNView *knnView;
    BOOL decisionBoundaryDrawn;
    NSOperationQueue *queue;
    uint64_t operationId;
    
    MLDataPoint *lastTouchedPoint;
}

@property (nonatomic, weak) KNNSideController *sideController;
@property (nonatomic, assign) NSUInteger k;
@property (nonatomic, assign) BOOL classifyStatus;
@property (nonatomic, strong) KNN *knn;

-(void) deleteSelectedData;
-(void) removeAllData;
-(void) drawDecisionBoundary;
-(void) changeLabel:(NSUInteger)label;
@end
