//
//  MLMasterViewController.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/22/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVMDetailViewController;
@class KNNController;
@interface MLMasterViewController : UITableViewController

@property (strong, nonatomic) KNNController *knnController;
@property (strong, nonatomic) SVMDetailViewController *svmController;

@end
