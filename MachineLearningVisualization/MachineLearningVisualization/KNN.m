//
//  KNN.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/27/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "KNN.h"
#import "MLDataPoint.h"
@implementation KNN
@synthesize testingData,trainingData,results;
@synthesize dataPoints = dataPoints;
@synthesize k=_k;
-(id) init{
    if (self=[super init]) {
        dataPoints = [[NSMutableSet alloc] init];
        _k=3;
    }
    return self;
}

-(void)addDataPoint:(MLDataPoint *)dataPoint{
    [dataPoints addObject:dataPoint];
}

-(NSUInteger) classify:(CGPoint)point{
    NSMutableArray *datas = [[NSMutableArray alloc] initWithCapacity:dataPoints.count];
    for (MLDataPoint *p in dataPoints) {
        [datas addObject:p];
    }
    [datas sortUsingFunction:comparePointDistances context:(void *)[NSValue valueWithCGPoint:point]];
    
    int i=0;
    int pos=0;
    int neg=0;
    for (MLDataPoint *p in datas) {
        if (i==_k) {
            break;
        }
        if (p.label==0) {
            pos++;
        } else {
            neg++;
        }
        i++;
    }
    
    return pos>neg?0:1;
}
NSInteger comparePointDistances(id o0, id o1, void *context){
    CGPoint newPoint = [(__bridge NSValue *)context CGPointValue];
    MLDataPoint *p0 = (MLDataPoint *)o0;
    MLDataPoint *p1 = (MLDataPoint *)o1;
    double distance0 = (p0.x - newPoint.x)*(p0.x - newPoint.x)+(p0.y - newPoint.y)*(p0.y - newPoint.y);
    double distance1 = (p1.x - newPoint.x)*(p1.x - newPoint.x)+(p1.y - newPoint.y)*(p1.y - newPoint.y);
    if (distance0 > distance1) {
        return NSOrderedDescending;
    } else if(distance0 < distance1){
        return NSOrderedAscending;
    }
    return NSOrderedSame;
}
-(NSArray *) decisionBoundaryForStep:(NSUInteger)step onViewSize:(CGSize)size{
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    NSMutableArray *datas = [[NSMutableArray alloc] initWithCapacity:dataPoints.count];
    for (MLDataPoint *p in dataPoints) {
        [datas addObject:p];
    }
    int count = datas.count;
    for (int x=step/2; x<size.width+step; x=x+step) {
        for (int y=step/2; y<size.height+step; y=y+step) {
            //perform the selection algorithm here:
            
            for (int i=0; i<_k; i++) {
                int minIndex = i;
                MLDataPoint *nearestPoint = [datas objectAtIndex:i];
                double distance = (nearestPoint.x - x)*(nearestPoint.x - x)+(nearestPoint.y - y)*(nearestPoint.y - y);
                for (int j=i+1; j<count; j++) {
                    MLDataPoint *currentPoint = [datas objectAtIndex:j];
                    double newDistance = (currentPoint.x - x)*(currentPoint.x - x)+(currentPoint.y - y)*(currentPoint.y - y);
                    if (newDistance<distance) {
                        minIndex = j;
                        nearestPoint = currentPoint;
                        distance = newDistance;
                    }
                }
            [datas exchangeObjectAtIndex:i withObjectAtIndex:minIndex];
        }
        
        int i=0;
        int pos=0;
        int neg=0;
        for (MLDataPoint *p in datas) {
            if (i==_k) {
                break;
            }
            if (p.label==0) {
                pos++;
            } else {
                neg++;
            }
            i++;
        }
        
        [labels addObject:[NSNumber numberWithUnsignedInt:pos>neg?0:1]]; 
    }
}    
return labels;
}
@end
