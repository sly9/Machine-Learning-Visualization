//
//  KNNController.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/27/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNNAlgorithm;
@class KNN;
@interface KNNController : UIViewController{
    KNNAlgorithm *knnAlgorithm;
    KNN *knn;
}

- (IBAction)test:(id)sender;



@end
