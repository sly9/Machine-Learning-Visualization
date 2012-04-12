//
//  KNN.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/27/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNN : UIView

@property (nonatomic, strong) NSArray *trainingData;
@property (nonatomic, strong) NSArray *testingData;
@property (nonatomic, strong) NSArray *results;


@end
