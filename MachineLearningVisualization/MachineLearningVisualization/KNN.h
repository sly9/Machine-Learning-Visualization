//
//  KNN.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/27/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLDataPoint;
@interface KNN : NSObject {
    NSMutableSet *dataPoints;
}


@property (nonatomic, strong) NSArray *trainingData;
@property (nonatomic, strong) NSArray *testingData;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, assign) NSUInteger k;
@property (nonatomic, readonly) NSMutableSet *dataPoints;

-(void) addDataPoint:(MLDataPoint *)dataPoint;
-(NSUInteger) classify:(CGPoint)point;

-(NSArray *) decisionBoundaryForStep:(NSUInteger)step onViewSize:(CGSize)size;

@end
