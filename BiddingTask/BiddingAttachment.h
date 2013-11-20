//
//  BiddingAttachment.h
//  BiddingTask
//
//  Created by Menethil on 13-11-13.
//  Copyright (c) 2013年 Menethil. All rights reserved.
//

#import <Foundation/Foundation.h>

//附件项
@interface BiddingAttachment : NSObject
@property (strong, nonatomic) NSString *title;  //附件标题
@property (strong, nonatomic) NSString *fileName;   //文件名
@property (strong, nonatomic) NSString *downloadUrl;    //下载地址
@end
