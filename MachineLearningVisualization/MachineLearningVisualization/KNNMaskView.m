//
//  KNNMaskView.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 4/16/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "KNNMaskView.h"
#import "MLAppDelegate.h"
@implementation KNNMaskView

- (id)init
{
    //MLAppDelegate *delegate = (MLAppDelegate *)[UIApplication sharedApplication].delegate;

    if ((self = [super init])) {
        NSArray * nib = [[NSBundle mainBundle] 
                         loadNibNamed: @"KNNMask" 
                         owner: self 
                         options: nil];
        
        self = [nib objectAtIndex:0];
        scrollView = [self.subviews objectAtIndex:0];
        UIImage *image = [UIImage imageNamed:@"mask.png"];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView addSubview:imageView];
        imageView=[[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView addSubview:imageView];
        imageView=[[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(scrollView.frame.size.width*2, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView addSubview:imageView];
        imageView=[[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(scrollView.frame.size.width*3, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView addSubview:imageView];
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*4, scrollView.frame.size.height);

        scrollView.delegate = self;
    }
    

    /*
    if (self = [super initWithFrame:CGRectMake(0, 0, 1024, 768)]) {
        // Initialization code
        UIImage *image = [UIImage imageNamed:@"mask.png"];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
        imageView.frame = self.frame;
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        
        [self addSubview:imageView];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:gestureRecognizer];
        
    }*/
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)tap
{
    [self removeFromSuperview];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging, offset: %@",NSStringFromCGPoint(scrollView.contentOffset));
    if (scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished){
            [self removeFromSuperview]; 
        }];
    }
    
    
}



@end
