//
//  ViewController.m
//  checkFlow
//
//  Created by yueyang on 16/5/12.
//  Copyright © 2016年 yueyang. All rights reserved.
//

#import "ViewController.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#import "checkWifiFlow.h"
@interface ViewController ()
{
    NSDictionary *infoDic;
}
@property(nonatomic,weak) IBOutlet UITextView *info;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
   
}

-(IBAction)  checkflow:(id)sender
{
     infoDic = [checkWifiFlow checkNetworkflow];
    NSString *str = [NSString stringWithFormat:@"receivedBytes==%@\nsentBytes==%@\nnetworkFlow==%@\nwifiReceived==%@\nwifiSent==%@\nwifiBytes==%@\n",infoDic[@"receivedBytes"],infoDic[@"sentBytes"],infoDic[@"networkFlow"],infoDic[@"wifiReceived"],infoDic[@"wifiSent"],infoDic[@"wifiBytes"]];
    
    _info.text = str;
}


@end
