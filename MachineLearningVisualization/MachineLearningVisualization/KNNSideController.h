//
//  KNNSideController.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 4/15/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNNSideController : UIViewController {
    BOOL classificationStatus;
}
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchButton;
- (IBAction)switchStatus:(id)sender;

@end
