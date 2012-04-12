//
//  MLDataPoint.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 4/10/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLDataPoint : NSObject
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) NSUInteger label;

-(id) initWithX:(CGFloat)x Y:(CGFloat)y andLabel:(NSUInteger)label;

@end
