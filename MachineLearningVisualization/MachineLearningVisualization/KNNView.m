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
        decisionView = [[UIView alloc] initWithFrame:self.frame];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 600, 100)];
        textLabel.font = [UIFont systemFontOfSize:48];
        textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        textLabel.tag = 0;
        textLabel.backgroundColor =[UIColor clearColor];
        [decisionView addSubview:textLabel];
        
        [self addSubview:decisionBoundaryView];
        [self addSubview:circlesView];
        [self addSubview:decisionView];
        
        circles = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)updateView{
    [CATransaction setDisableActions:YES];
    
    for (MLDataPoint *point in self.knn.pointsToAdd) {
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
    
    for (MLDataPoint *fromPoint in self.knn.pointsToMove.allKeys) {
        CALayer *layer = [circles objectForKey:fromPoint];
        MLDataPoint *toPoint = [self.knn.pointsToMove objectForKey:fromPoint];
        
        layer.position = CGPointMake(toPoint.x, toPoint.y);
        [circles removeObjectForKey:fromPoint];
        [circles setObject:layer forKey:toPoint];
    }
    
    for (MLDataPoint *point in self.knn.pointsToDelete) {
        CALayer *layer = [circles objectForKey:point];
        [layer removeFromSuperlayer];
    }
    
    [self.knn clearBuffer];
}

-(void)updateDecisionBoundaryWithLabels:(NSArray *)labels andSize:(NSUInteger)step{
    // NSLog(@"updateDecision Boundary with step %d",step);
    [decisionBoundaryView removeFromSuperview];
    decisionBoundaryView = [[UIView alloc] initWithFrame:
                            CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    // CGRect bound = CGRectMake(0, 0, width*2, height*2);
    // decisionBoundaryView.bounds = bound;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL,width,height,8,width * 4,colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    int i = 0;
    for (int x=step/2; x<=width+step*1.5; x=x+step) {
        for (int y=step/2; y<=height+step*1.5; y=y+step) {
            NSUInteger label = [[labels objectAtIndex:i] unsignedIntValue];
            //CALayer *layer = [CALayer layer];
            if (label == 0) {
                CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5] CGColor]);
            } else if(label == 1) {
                CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5] CGColor]);
            } else {
                CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5] CGColor]);
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
-(void) drawDecisionForPoint:(CGPoint)location withNeighbors:(NSArray *)neighbors{
    double largestRadius = 0;
    
    NSMutableSet *layers = [[NSMutableSet alloc] init];
    
    
    
    NSMutableDictionary *distances = [[NSMutableDictionary alloc] init];
    for (MLDataPoint *p in neighbors) {
        double distance = sqrt((location.x-p.x)*(location.x-p.x)+(location.y-p.y)*(location.y-p.y));
        if (distance > largestRadius) {
            largestRadius = distance;
        }
        [distances setObject:[NSNumber numberWithDouble:distance] forKey:p];
    }
    CGRect oldBounds = CGRectMake(location.x-1 , location.y-1, 1*2, 1*2);
    CGRect newBounds = CGRectMake(location.x-largestRadius , location.y-largestRadius, largestRadius*2, largestRadius*2);
    CGFloat oldRadius = 1.0;
    CGFloat newRadius = largestRadius;
    
    CALayer *centerLayer = [CALayer layer];
    [layers addObject:centerLayer];
    centerLayer.backgroundColor = [UIColor grayColor].CGColor;
    centerLayer.bounds = CGRectMake(location.x - 12, location.y - 12, 24, 24);
    centerLayer.masksToBounds = YES;
    centerLayer.cornerRadius = 12;
    centerLayer.position = CGPointMake(location.x, location.y);
    [decisionView.layer addSublayer:centerLayer];
    
    
    
    CALayer *circleLayer = [CALayer layer];
    [layers addObject:circleLayer];
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    circleLayer.borderColor = [UIColor blackColor].CGColor;
    circleLayer.borderWidth = 2.0;
    circleLayer.bounds = oldBounds;
    circleLayer.masksToBounds = YES;
    
    circleLayer.cornerRadius = oldRadius;
    circleLayer.position = CGPointMake(location.x, location.y);
    
    [decisionView.layer addSublayer:circleLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.fromValue = [NSValue valueWithCGRect:oldBounds];
    animation.toValue = [NSValue valueWithCGRect:newBounds];
    animation.duration = 2.0;
    // Update the layer's bounds so the layer doesn't snap back when the animation completes.
    circleLayer.bounds = newBounds;
    
    // Add the animation, overriding the implicit animation.
    [circleLayer addAnimation:animation forKey:@"bounds"];
    animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.fromValue = [NSNumber numberWithDouble:oldRadius];
    animation.toValue = [NSNumber numberWithDouble:newRadius];
    animation.duration = 2.0;    
    // Update the layer's bounds so the layer doesn't snap back when the animation completes.
    circleLayer.cornerRadius = newRadius;
    
    // Add the animation, overriding the implicit animation.
    [circleLayer addAnimation:animation forKey:@"cornerRadius"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*5), dispatch_get_current_queue(), ^{
        circleLayer.opacity = 0;                   
    });
    
    
    //for each k points, draw a corresponding flashing
    for (MLDataPoint *p in neighbors) {
        double distance = sqrt((location.x-p.x)*(location.x-p.x)+(location.y-p.y)*(location.y-p.y));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*2*(distance/largestRadius)), dispatch_get_current_queue(), ^{
            CALayer *layer = [CALayer layer];
            [layers addObject:layer];
            layer.bounds = CGRectMake(p.x - 15, p.y-15, 30, 30);
            layer.masksToBounds = YES;
            if (p.label == 0) {
                layer.backgroundColor = [[UIColor redColor] CGColor];
            } else {
                layer.backgroundColor = [[UIColor blueColor] CGColor];
            }
            layer.borderWidth = 3;
            layer.borderColor = [UIColor colorWithRed:212.0/256 green:175.0/256 blue:55.0/256 alpha:1].CGColor;

            layer.cornerRadius = 15.0f;
            layer.position = CGPointMake(p.x, p.y);
            [decisionView.layer addSublayer:layer];
            
            textLabel.tag = textLabel.tag+1;
            textLabel.text = [NSString stringWithFormat:@"meet %d points so far",textLabel.tag];
            
        });
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*2.5), dispatch_get_current_queue(), ^{
        int pos=0;
        int neg=0;
        for (MLDataPoint *p in neighbors) {
            if (p.label == 0) {
                pos++;
            } else {
                neg++;
            }
        }
        if (pos > neg) {
            textLabel.text = [NSString stringWithFormat:@"Positive labels win!"];            
            centerLayer.backgroundColor = [UIColor redColor].CGColor;
        } else if(pos<neg) {
            textLabel.text = [NSString stringWithFormat:@"Negative labels win!"];            
            centerLayer.backgroundColor = [UIColor blueColor].CGColor;
        } else {
            textLabel.text = @"Draw...";
        }
        textLabel.tag=0;
        
    });

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*7), dispatch_get_current_queue(), ^{
        for (CALayer *layer in layers) {
            [layer removeFromSuperlayer];
        }
        textLabel.text = @"";
    });
    
    
}
@end
