//
//  DetailViewController.h
//  BiddingTask
//
//  Created by Menethil on 13-11-12.
//  Copyright (c) 2013年 Menethil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiddingItem.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) BiddingItem *detailItem;

@property (weak,nonatomic) IBOutlet UIWebView *webView;
@end
