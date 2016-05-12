//
//  checkWifiFlow.m
//  checkFlow
//
//  Created by yueyang on 16/5/12.
//  Copyright © 2016年 yueyang. All rights reserved.
//

#import "checkWifiFlow.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
@implementation checkWifiFlow

+(NSString *)bytesToAvaiUnit:(int)bytes
{
    if(bytes < 1024)     // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

+(NSDictionary *)checkNetworkflow{
    
    struct ifaddrs *ifa_list = 0, *ifa;
    
    if (getifaddrs(&ifa_list) == -1)
        
    {
        
        return nil;
    }
    
    uint32_t iBytes     = 0;
    
    uint32_t oBytes     = 0;
    
    uint32_t allFlow    = 0;
    
    uint32_t wifiIBytes = 0;
    
    uint32_t wifiOBytes = 0;
    
    uint32_t wifiFlow   = 0;
    
//    uint32_t wwanIBytes = 0;
//    
//    uint32_t wwanOBytes = 0;
//    
//    uint32_t wwanFlow   = 0;
    
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
        
    {
        
        if (AF_LINK != ifa->ifa_addr->sa_family)
            
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            
            continue;
        
        if (ifa->ifa_data == 0)
            
            continue;
        // 总流量
        
        if (strncmp(ifa->ifa_name, "lo", 2))
            
        {
            
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            
            oBytes += if_data->ifi_obytes;
            
            allFlow = iBytes + oBytes;
            
        }
        
        //WIFI流量统计
        
        if (!strcmp(ifa->ifa_name, "en0"))
            
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            wifiIBytes += if_data->ifi_ibytes;
            
            wifiOBytes += if_data->ifi_obytes;
            
            wifiFlow    = wifiIBytes + wifiOBytes;
            
        }
        
        //3G和GPRS流量统计
        
//        if (!strcmp(ifa->ifa_name, "pdp_ip0"))
//            
//        {
//            
//            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
//            
//            wwanIBytes += if_data->ifi_ibytes;
//            
//            wwanOBytes += if_data->ifi_obytes;
//            
//            wwanFlow    = wwanIBytes + wwanOBytes;
//
//            
//        }
        
    }
    
    freeifaddrs(ifa_list);
    
    
    
    NSString* receivedBytes= [self bytesToAvaiUnit:iBytes];
    NSLog(@"receivedBytes==%@",receivedBytes);
    
    NSString *sentBytes       = [self bytesToAvaiUnit:oBytes];
    NSLog(@"sentBytes==%@",sentBytes);
    
    NSString *networkFlow      = [self bytesToAvaiUnit:allFlow];
    NSLog(@"networkFlow==%@",networkFlow);
    
    NSString *wifiReceived   = [self bytesToAvaiUnit:wifiIBytes];
    NSLog(@"wifiReceived==%@",wifiReceived);
    
    NSString *wifiSent       = [self bytesToAvaiUnit: wifiOBytes];
    NSLog(@"wifiSent==%@",wifiSent);
    
    NSString *wifiBytes      = [self bytesToAvaiUnit:wifiFlow];
    NSLog(@"wifiBytes==%@",wifiBytes);
//    NSString *wwanReceived   = [self bytesToAvaiUnit:wwanIBytes];
//    
//    NSLog(@"wwanReceived==%@",wwanReceived);
//    NSString *wwanSent       = [self bytesToAvaiUnit:wwanOBytes];
//    
//    NSLog(@"wwanSent==%@",wwanSent);
//    NSString *wwanBytes      = [self bytesToAvaiUnit:wwanFlow];
//    
//    NSLog(@"wwanBytes==%@",wwanBytes);
    NSDictionary *dic = @{@"receivedBytes":receivedBytes,@"sentBytes":sentBytes,@"networkFlow":networkFlow,@"wifiReceived":wifiReceived,@"wifiSent":wifiSent,@"wifiBytes":wifiBytes};
    
    return dic;
}

@end
