//
//  RefreshViewController.h
//  快速集成下拉刷新
//
//  Created by mj on 13-11-3.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "AFNetworking.h"

@interface RefreshViewController : MasterViewController
{
    int currentPageNum;
}
@end
