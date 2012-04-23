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
-(id) initWithCGPoint:(CGPoint)p andLabel:(NSUInteger)label{
    if (self=[super init]) {
        _x=p.x;
        _y=p.y;
        _label=label;
    }
    return self;    
}

-(NSString *)description{
    return [NSString stringWithFormat:@"{Label:%d, X:%f, Y:%f}",_label,_x,_y];
}


-(id) copyWithZone: (NSZone *) zone {
    MLDataPoint *newPoint = [[MLDataPoint allocWithZone:zone] init];
    newPoint.x = _x;
    newPoint.y = _y;
    newPoint.label = _label;
    
    return(newPoint);
}


- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToPoint:other];
}

- (BOOL)isEqualToPoint:(MLDataPoint *)aPoint {
    if (self == aPoint)
        return YES;
    return (_x== aPoint->_x) &&(_y==aPoint->_y);
}
- (NSUInteger)hash{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime * result + [[NSNumber numberWithDouble:_x] hash];
    result = prime * result + [[NSNumber numberWithDouble:_y] hash];
    return result;
}


@end
