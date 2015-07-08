//
//  LoginViewController.m
//  SNS_Login&Register_Post
//
//  Created by LZXuan on 15-5-22.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "LoginViewController.h"
#import "LZXHttpRequest.h"
#import "DetailViewController.h"
#import "Define.h"

@interface LoginViewController ()
{
    LZXHttpRequest *_httpRequest;
}
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *paddwdTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UIButton *registerButton;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)registerClick:(id)sender;
- (IBAction)loginClick:(id)sender;

@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建请求
    _httpRequest = [[LZXHttpRequest alloc] init];
    
}
- (void)dealloc {
    [_httpRequest release];
    [_nameTextField release];
    [_paddwdTextField release];
    [_emailTextField release];
    [_registerButton release];
    [_loginButton release];
    [super dealloc];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nameTextField resignFirstResponder];
    [self.paddwdTextField resignFirstResponder];
}
#pragma mark - 警告框
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}


- (IBAction)registerClick:(id)sender {
    if (self.nameTextField.text == nil||self.paddwdTextField.text == nil) {
        [self showAlertViewWithTitle:@"警告" message:@"用户名或者密码不能为空"];
        return;
    }
    NSDictionary *dict = @{
        @"username":self.nameTextField.text,
        @"password":self.paddwdTextField.text,
        @"email":self.emailTextField.text
        };
    //下面把一个url 转化为合法的 (url中不能有中文和其他非法字符)
    NSString *url = [REGISTER_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //点击注册 要把 用户名 密码 邮箱提交给 服务器
    [_httpRequest postRequestWithUrl:url param:dict contentType:@"application/x-www-form-urlencoded" success:^(LZXHttpRequest *httpRequest) {
        //接收到服务器的反馈数据
        //给的是json 格式
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:httpRequest.downloadData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict:%@",dict);
        if ([dict[@"code"] isEqualToString:@"registered"]) {
            //注册成功
            [self showAlertViewWithTitle:@"恭喜" message:@"注册成功"];
        }else{
            //注册失败
            [self showAlertViewWithTitle:@"警告" message:dict[@"message"]];
        }
    } failed:^(NSError *error) {
        NSLog(@"下载失败");
    }];
    
}
/*
 成功
 {
 "code":"registered", 
 "message":"注册成功了,进入个人空间"
 }
 失败
 {
 "code":!"user_name_already_exists",
 "message":"用户名已经存在"
 }
 */

- (IBAction)loginClick:(id)sender {
    if (self.nameTextField.text == nil||self.paddwdTextField.text == nil) {
        [self showAlertViewWithTitle:@"警告" message:@"用户名或者密码不能为空"];
        return;
    }

      NSDictionary *dict = @{
                       @"username":self.nameTextField.text,
                       @"password":self.paddwdTextField.text,
                       };
    [_httpRequest postRequestWithUrl:LOGIN_URL param:dict contentType:@"application/x-www-form-urlencoded" success:^(LZXHttpRequest *httpRequest) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:httpRequest.downloadData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict:%@",dict);
        if ([dict[@"code"] isEqualToString:@"login_success"]) {

            //服务器会返回一个(dict[m_auth])就是一个  token (就是一个令牌，表示登录成功,一般要做本地保存) 如果有这个token 表示 登录成功
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"m_auth"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //登录成功
            //界面跳转
            DetailViewController *detail = [[DetailViewController alloc] init];
            [self.navigationController pushViewController:detail animated:YES];
            [detail release];
            
            
        }else{
            [self showAlertViewWithTitle:@"警告" message:dict[@"message"]];
        }
        
        
    } failed:^(NSError *error) {
        
    }];
    
    
}
/*
 {
 code = "login_success";
 expiretime = 31536000;
 "m_auth" = "c1b262jHNBT0HH+irf3YUeZy0+KTH1KnBElVhK5miPuRQbFjMy4GWyDUlCIZRZ8a1IPRqjh2MPvs8dB61f7Q+Z1vOEE";
 message = "\U767b\U5f55\U6210\U529f\U4e86\Uff0c\U73b0\U5728\U5f15\U5bfc\U60a8\U8fdb\U5165\U767b\U5f55\U524d\U9875\U9762 ";
 uid = 124874;
 }

 */

@end





