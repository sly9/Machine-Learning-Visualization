//
//  KNNView.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/27/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KNN;
@interface KNNView : UIView {
    NSMutableDictionary *circles;
    UIView *decisionView;
    UIView *circlesView;
    UIView *decisionBoundaryView;
    UILabel *textLabel;
}


@property (nonatomic, strong) KNN *knn;

-(void)updateView;
//-(void)updateDecisionBoundaryWithPoints:(NSArray *)points andLabels:(NSArray *)labels andSize:(CGSize)size;
-(void)updateDecisionBoundaryWithLabels:(NSArray *)labels andSize:(NSUInteger)size;

-(void) drawDecisionForPoint:(CGPoint)location withNeighbors:(NSArray *)neighbors;
@end
