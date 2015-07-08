//
//  LZXHttpRequest.m
//  SNSDemo
//
//  Created by LZXuan on 15-5-21.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "LZXHttpRequest.h"

@interface LZXHttpRequest ()
@property (nonatomic,copy) DownloadSuccessBlock success;
@property (nonatomic,copy) DownloadFailedBlock failed;
@end

@implementation LZXHttpRequest
- (void)dealloc {
    self.success = nil;
    self.failed = nil;
    [_downloadData release];
    [super dealloc];
}
- (instancetype)init {
    if (self = [super init]) {
        //初始化的时候创建一个空的可变二进制数据对象
        _downloadData = [[NSMutableData alloc] init];
    }
    return self;
}
- (void)downloadDataWithUrl:(NSString *)url
                    success:(DownloadSuccessBlock)successBlock
                     failed:(DownloadFailedBlock)failedBlock{
    
    if (_httpRequest) {
        //先判断 之前有没有下载连接
        [_httpRequest release];
        _httpRequest = nil;
    }
    //保存block
    self.success = successBlock;
    self.failed = failedBlock;
    
    
    //创建新的连接请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //创建新的连接
    _httpRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}
#pragma mark UIURLConnectionDataDelegate
//客户端 和 服务端 连接之后，客户端收到服务器的响应
//服务器告知 客户端 发的数据类型/数据长度
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //先把之前的连接下载的数据 清空
    [self.downloadData setLength:0];//清空
}
//客户端收到服务器的数据的时候调用
//下面方法会被调用多次 数据一般一段一段发送
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadData appendData:data];//拼接
}
//数据下载完成之后调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //当前 LZXHttpRequest下载完成数据之后 不处理数据，这时需要委托 别人来处理下载数据
    //我们可以采用代理设计模式
    //3.block
    //通知代理  数据下载完成
    
    if (self.success) {
        //调用block  把 当前下载对象 传给别人 别人就可以 通过 当前对象的downloadData 就可以获取 下载的数据
        self.success(self);
    }else {
        NSLog(@"没有传block");
    }
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"网络有异常:%@",error);
    
    if (self.failed) {
        //下载失败 回调 把错误传给 别人
        self.failed(error);
    }
    
}
//客户端给服务器发数据(提交/上传)请求

//服务器给客户端发数据(发送响应，客户端获取数据)
//不管post 还是 get 上面的方法 客户端都会执行


//post请求
- (void)postRequestWithUrl:(NSString *)url
                     param:(NSDictionary *)dict
               contentType:(NSString *)type
                   success:(DownloadSuccessBlock)successBlock
                    failed:(DownloadFailedBlock)failedBlock {
    if (_httpRequest) {
        [_httpRequest release];
        _httpRequest = nil;
    }
    self.success = successBlock;//保存block
    self.failed = failedBlock;
    
    //创建可变的请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //设置请求方式 默认是GET
    request.HTTPMethod = @"POST";
    /*
     四种常见的 POST 提交数据方式  body请求体
     常见四种
     提交表单
     1.application/x-www-form-urlencoded 参数拼接形式
     2.multipart/x-www-form-data  参数是二进制数据 如上传文件
     3.application/json  参数 是json 格式
     4.text/xml 参数是xml格式
     */
    //请求的类型(添加到请求头)
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    
    //提交的数据 按照参数拼接的形式(放入请求体)
    //key1=value1&key2=value2---》然后转化为NSData 二进制
    //把dict 中键值对数据 拼接成 参数拼接的形式
    NSInteger i = 0;
    NSString *str = @"";
    for (NSString *key in dict) {
        //拼接
        if (i == 0) {
            str = [str stringByAppendingFormat:@"%@=%@",key,dict[key]];
        }else{
            str = [str stringByAppendingFormat:@"&%@=%@",key,dict[key]];
        }
        i++;
    }
    NSLog(@"%@",str);
    //转化为NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    //设置请求体的长度 添加到请求头
    [request setValue:[NSString stringWithFormat:@"%ld",data.length] forHTTPHeaderField:@"Content-Length"];
    //设置请求体
    request.HTTPBody = data;
    
    //post/get 包含 请求头和请求体 一般get不需要请求头和请求体
    
    //下面 建立请求连接
    _httpRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //连接成功之后会执行协议中的 方法
}


@end








