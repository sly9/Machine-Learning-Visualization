//
//  KNNSideController.h
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 4/15/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KNNController;
@interface KNNSideController : UIViewController {
    BOOL classificationStatus;
}
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchButton;
- (IBAction)switchStatus:(id)sender;
- (IBAction)changeK:(id)sender;
- (IBAction)decisionBoundary:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *console;
- (IBAction)deleteDataPoint:(id)sender;
- (IBAction)clearDataPoint:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *kLabel;

- (IBAction)changeLabel:(id)sender;

@property (weak, nonatomic) KNNController *mainController;
-(void) appendLog:(NSString *)log;
@end
