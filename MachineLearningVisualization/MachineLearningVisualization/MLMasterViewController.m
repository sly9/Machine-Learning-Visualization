//
//  MLMasterViewController.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/22/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "MLMasterViewController.h"
#import "KNNController.h"
#import "SVMDetailViewController.h"
#import "MLAppDelegate.h"
#import "KNNMaskView.h"
#import "KNNSideController.h"

@interface MLMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MLMasterViewController
@synthesize knnController=_knnController;
@synthesize svmController=_svmController;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    UIStoryboard *storyboard = self.storyboard;

    KNNController *knnController = [storyboard instantiateViewControllerWithIdentifier:@"KNNController"];
    
    SVMDetailViewController *svmController = [storyboard instantiateViewControllerWithIdentifier:@"SVMDetailController"];
    
    self.knnController = knnController;
    self.svmController = svmController;
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Table View
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select %@",indexPath);
//    NSDate *object = [_objects objectAtIndex:indexPath.row];

    
    if (indexPath.row == 0) {
        [self setDetailViewController:self.knnController];
        KNNMaskView *maskView = [[KNNMaskView alloc] init];
        MLAppDelegate *delegate = (MLAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:maskView];


    } else {
        [self setDetailViewController:self.svmController];
    }
    
}

-(void) setDetailViewController:(UIViewController *)controller
{
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:[self.splitViewController.viewControllers objectAtIndex:0],controller, nil];
}

@end
