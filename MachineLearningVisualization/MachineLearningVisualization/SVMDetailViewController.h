//
//  MLDetailViewController.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/22/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SVMLight/svm_common.h>
#import <SVMLight/svm_learn.h>

@interface SVMDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
- (IBAction)trainData:(id)sender;
- (IBAction)testData:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textfield;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
