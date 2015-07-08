//
//  LZXHttpRequest.h
//  SNSDemo
//
//  Created by LZXuan on 15-5-21.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 一个app 往往 有多个界面要进行下载数据，这时我们可以封装一个专门下载数据的类，这样如果界面需要下载数据我们只需创建下载对象去下载数据就可以了，封装之后可以降低代码耦合性，提高复用性
 */
// LZXHttpRequest只管下载数据，下完成之后 不知如何处理，这时可以委托代理来完成

//通过block 进行回调
//下载完成之后 block 回调 处理数据
@class LZXHttpRequest;
//定义两个block 类型
typedef  void (^ DownloadSuccessBlock)(LZXHttpRequest * httpRequest);
typedef  void (^ DownloadFailedBlock)(NSError * error);


@interface LZXHttpRequest : NSObject <NSURLConnectionDataDelegate>
{
    //下载请求连接
    NSURLConnection *_httpRequest;
    //可变的二进制数据保存下载
    NSMutableData *_downloadData;
}

//方便外接访问
@property (nonatomic,retain)NSMutableData *downloadData;

//下载get请求方法 --》下载数据 把两个block 传入
- (void)downloadDataWithUrl:(NSString *)url
                    success:(DownloadSuccessBlock)successBlock
                     failed:(DownloadFailedBlock)failedBlock;
//post请求链接
//把参数 和请求类型 传入
//传入服务响应成功 回调
- (void)postRequestWithUrl:(NSString *)url
                     param:(NSDictionary *)dict
               contentType:(NSString *)type
                   success:(DownloadSuccessBlock)successBlock
                    failed:(DownloadFailedBlock)failedBlock;

@end











