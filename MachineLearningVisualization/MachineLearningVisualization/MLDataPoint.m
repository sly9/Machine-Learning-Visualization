//
//  MLDataPoint.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 4/10/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "MLDataPoint.h"

@implementation MLDataPoint
@synthesize x=_x,y=_y,label=_label;

-(id) initWithX:(CGFloat)x Y:(CGFloat)y andLabel:(NSUInteger)label{
    if (self=[super init]) {
        _x=x;
        _y=y;
        _label=label;
    }
    return self;
}

@end
