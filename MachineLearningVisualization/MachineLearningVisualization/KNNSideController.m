//
//  KNNSideController.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 4/15/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "KNNSideController.h"
#import <QuartzCore/QuartzCore.h>
#import "MLMasterViewController.h"
#import "KNNController.h"
#import "KNN.h"
@interface KNNSideController ()

@end

@implementation KNNSideController
@synthesize firstView;
@synthesize secondView;
@synthesize switchButton;
@synthesize console;
@synthesize kLabel;
@synthesize mainController=_mainController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        classificationStatus = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.secondView.hidden = YES;
    self.firstView.hidden = NO;
    self.secondView.layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0);
}

- (void)viewDidUnload
{
    [self setSecondView:nil];
    [self setFirstView:nil];
    [self setSwitchButton:nil];
    [self setConsole:nil];
    [self setKLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated
{
    MLMasterViewController *masterViewController = [self.navigationController.viewControllers objectAtIndex:0];
    self.mainController = masterViewController.knnController;
    self.mainController.sideController = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)switchStatus:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.layer.transform = CATransform3DMakeRotation(M_PI_2,0.0,1.0,0.0); //flip halfway
    } completion:^(BOOL finished){
        self.secondView.hidden = classificationStatus;
        self.firstView.hidden = !classificationStatus;
        
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0); //finish the flip
        } completion:^(BOOL finished){
            // Flip completion code here
            if (!classificationStatus) {
                self.firstView.layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0);
            }
            classificationStatus = !classificationStatus;
            if (classificationStatus) {
                self.switchButton.title = @"add data";
            } else {
                self.switchButton.title = @"classify";
            }
            self.mainController.classifyStatus = classificationStatus;
        }];
    }];
}

- (IBAction)changeK:(id)sender {
    NSUInteger newK = (NSUInteger)((UISlider *)sender).value;
    NSUInteger currentK = self.mainController.k;
    if (newK != currentK) {
        self.mainController.k=newK;
        self.mainController.knn.k=newK;
        self.kLabel.text = [NSString stringWithFormat:@"K=%d",newK];
        [self appendLog:self.kLabel.text];
    }
}

- (IBAction)decisionBoundary:(id)sender {
    [self.mainController drawDecisionBoundary];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"id: %@",segue.identifier);
}

-(void) appendLog:(NSString *)log
{
    NSLog(@"append log %@!",log);
//    self.console.text=[NSString stringWithFormat:@"%@\n%@", self.console.text,log];
}
- (IBAction)deleteDataPoint:(id)sender {
    [self.mainController deleteSelectedData];
}

- (IBAction)clearDataPoint:(id)sender {
    [self.mainController removeAllData];
}
- (IBAction)changeLabel:(id)sender {
    [self.mainController changeLabel:((UISegmentedControl *)sender).selectedSegmentIndex];
}
@end
