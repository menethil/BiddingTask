//
//  BiddingItem.h
//  BiddingTask
//
//  Created by Menethil on 13-11-13.
//  Copyright (c) 2013年 Menethil. All rights reserved.
//

#import <Foundation/Foundation.h>

//招标项目
@interface BiddingItem : NSObject
@property (strong, nonatomic) NSString *title;  //标题
@property (strong, nonatomic) NSString *no;     //招标编号
@property (strong, nonatomic) NSString *url;    //网络地址
@property (strong, nonatomic) NSMutableArray *attachments;  //附件列表
@property (strong, nonatomic) NSString *date;   //招标日期
@end
