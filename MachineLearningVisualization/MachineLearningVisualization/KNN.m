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
@synthesize dataPoints = _dataPoints;
@synthesize k=_k;
@synthesize pointsToMove=_pointsToMove,pointsToDelete=_pointsToDelete,pointsToAdd=_pointsToAdd;
-(id) init{
    if (self=[super init]) {
        _dataPoints = [[NSMutableSet alloc] init];
        _pointsToAdd = [[NSMutableSet alloc] init];
        _pointsToMove = [[NSMutableDictionary alloc] init];
        _pointsToDelete = [[NSMutableSet alloc] init];

        _k=3;
    }
    return self;
}

-(void)addDataPoint:(MLDataPoint *)dataPoint{
    [_dataPoints addObject:dataPoint];
    [_pointsToAdd addObject:dataPoint];
}
-(void) moveDataPointFrom:(MLDataPoint *)from to:(MLDataPoint *)to{
    [_dataPoints removeObject:from];
    [_dataPoints addObject:to];
    //key:from, value:to
    [_pointsToMove setObject:to forKey:from];
}

-(NSArray *) nearestKPoints:(CGPoint)point {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSMutableArray *datas = [[NSMutableArray alloc] initWithCapacity:_dataPoints.count];
    for (MLDataPoint *p in _dataPoints) {
        [datas addObject:p];
    }
    int count = datas.count;

    for (int i=0; i<_k; i++) {
        int minIndex = i;
        MLDataPoint *nearestPoint = [datas objectAtIndex:i];
        double distance = (nearestPoint.x - point.x)*(nearestPoint.x - point.x)+(nearestPoint.y - point.y)*(nearestPoint.y - point.y);
        for (int j=i+1; j<count; j++) {
            MLDataPoint *currentPoint = [datas objectAtIndex:j];
            double newDistance = (currentPoint.x - point.x)*(currentPoint.x - point.x)+(currentPoint.y - point.y)*(currentPoint.y - point.y);
            if (newDistance<distance) {
                minIndex = j;
                nearestPoint = currentPoint;
                distance = newDistance;
            }
        }
        [datas exchangeObjectAtIndex:i withObjectAtIndex:minIndex];
        [result addObject:[datas objectAtIndex:i]];
    }
    

    return  result;
}


-(void) setDataPoints:(NSMutableSet *)dataPoints{
    @synchronized(self){
        _dataPoints = dataPoints;
    }
}

-(NSArray *) decisionBoundaryForStep:(NSUInteger)step onViewSize:(CGSize)size{
    @synchronized(self){
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    NSMutableArray *datas = [[NSMutableArray alloc] initWithCapacity:_dataPoints.count];
    for (MLDataPoint *p in _dataPoints) {
        [datas addObject:p];
    }
    int count = datas.count;
    for (int x=step/2; x<=size.width+step*1.5; x=x+step) {
        for (int y=step/2; y<=size.height+step*1.5; y=y+step) {
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
            if (pos>neg) {
                [labels addObject:[NSNumber numberWithUnsignedInt:0]]; 
            } else if(pos<neg) {
                [labels addObject:[NSNumber numberWithUnsignedInt:1]];
            } else {
                [labels addObject:[NSNumber numberWithUnsignedInt:-1]];
            }
        }
    }    
    return labels;
    }
}

-(void) clearBuffer{
    _pointsToAdd = [[NSMutableSet alloc] init];
    _pointsToMove = [[NSMutableDictionary alloc] init];
    _pointsToDelete = [[NSMutableSet alloc] init];    
}

- (MLDataPoint *)nearestDataPointFromPoint:(CGPoint)location{
    for (MLDataPoint *point in _dataPoints) {
        double distance = (location.x - point.x)*(location.x - point.x)+(location.y - point.y)*(location.y - point.y);
        if (distance <= 400) {
            return point;
        }
    }
    return nil;
}

@end
