//
//  checkWifiFlow.h
//  checkFlow
//
//  Created by yueyang on 16/5/12.
//  Copyright © 2016年 yueyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface checkWifiFlow : NSObject
@property(nonatomic,strong)NSString *receivedBytes;

+(NSDictionary *)checkNetworkflow;
@end
