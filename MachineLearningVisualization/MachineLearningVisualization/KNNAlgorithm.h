//
//  KNNAlgorithm.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/27/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNNAlgorithm : NSObject


-(NSData *)classify:(NSData *)testData withPoints:(NSData *)trainingData;
@end
