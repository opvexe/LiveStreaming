//
//  ViewController.m
//  LiveStreaming
//
//  Created by jieku on 2017/6/15.
//  Copyright © 2017年 jieku. All rights reserved.
//

#import "ViewController.h"
#import "LiveStreamView.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    LiveStreamView *live = [[LiveStreamView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:live];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
