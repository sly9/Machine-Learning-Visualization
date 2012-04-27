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

}

@property (atomic, assign) NSUInteger k;
@property (atomic, readonly) NSMutableSet *dataPoints;
@property (atomic, readonly) NSMutableSet *pointsToAdd;
@property (atomic, readonly) NSMutableDictionary *pointsToMove;
@property (atomic, readonly) NSMutableSet *pointsToDelete;

-(void) addDataPoint:(MLDataPoint *)dataPoint;
-(void) moveDataPointFrom:(MLDataPoint *)from to:(MLDataPoint *)to;

//-(NSUInteger) classify:(CGPoint)point;
-(NSArray *) nearestKPoints:(CGPoint)point;
-(NSArray *) decisionBoundaryForStep:(NSUInteger)step onViewSize:(CGSize)size;
-(void) clearBuffer;
- (MLDataPoint *)nearestDataPointFromPoint:(CGPoint)location;

@end
