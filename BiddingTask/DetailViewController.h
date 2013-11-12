//
//  DetailViewController.h
//  BiddingTask
//
//  Created by Menethil on 13-11-12.
//  Copyright (c) 2013年 Menethil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
