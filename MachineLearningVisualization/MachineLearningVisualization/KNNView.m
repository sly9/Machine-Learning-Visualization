//
//  KNNView.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/27/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "KNNView.h"
#import "KNN.h"
#import "MLDataPoint.h"
#import <QuartzCore/QuartzCore.h>
@implementation KNNView
@synthesize knn=_knn;

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        decisionBoundaryView = [[UIView alloc] initWithFrame:self.frame];
        circlesView = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:decisionBoundaryView];
        [self addSubview:circlesView];
        
        circles = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)updateView{
    for (MLDataPoint *point in self.knn.dataPoints) {
        if ([circles objectForKey:point]) {
            continue;
        }

        CALayer *layer = [CALayer layer];
        layer.bounds = CGRectMake(point.x - 10, point.y-10, 20, 20);
        layer.masksToBounds = YES;
        if (point.label == 0) {
            layer.backgroundColor = [[UIColor redColor] CGColor];
        } else {
            layer.backgroundColor = [[UIColor blueColor] CGColor];
        }
        
        layer.cornerRadius = 10.0f;
        layer.position = CGPointMake(point.x, point.y);
        [circlesView.layer addSublayer:layer];
        [circles setObject:layer forKey:point];
    }
    
}

-(void)updateDecisionBoundaryWithLabels:(NSArray *)labels andSize:(NSUInteger)step{
    NSLog(@"updateDecision Boundary with step %d",step);
    [decisionBoundaryView removeFromSuperview];
    decisionBoundaryView = [[UIView alloc] initWithFrame:
                            CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGContextRef context = CGBitmapContextCreate(NULL, 
                                                 width, 
                                                 height, 
                                                 8,                      /* bits per component*/
                                                 width * 4,   /* bytes per row */
                                                 colorSpace, 
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);;
    int i = 0;
    for (int x=step/2; x<width+step; x=x+step) {
        for (int y=step/2; y<height+step; y=y+step) {
            NSUInteger label = [[labels objectAtIndex:i] unsignedIntValue];
            //CALayer *layer = [CALayer layer];
            if (label == 0) {
                CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5] CGColor]);
            } else {
                CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5] CGColor]);
            }
            CGContextFillRect(context, CGRectMake(x-step/2, height-(y-step/2), step, step));
            i++;
        }
    }
    CGImageRef currentImage = CGBitmapContextCreateImage(context);
    // ... and set it to the canvas view's contents
    decisionBoundaryView.layer.contents = (__bridge id)currentImage;
    

    
    [self insertSubview:decisionBoundaryView belowSubview:circlesView];

}
@end
