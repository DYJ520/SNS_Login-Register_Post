//
//  Define.h
//  SNS_Login&Register_Post
//
//  Created by LZXuan on 15-5-22.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#ifndef SNS_Login_Register_Post_Define_h
#define SNS_Login_Register_Post_Define_h

//登录接口地址
#define LOGIN_URL @"http://10.0.8.8/sns/my/login.php"
//参数—》?username=%@&password=%@
//登录接口类型
#define LOGIN_TYPE 1


//注册接口地址
#define REGISTER_URL @"http://10.0.8.8/sns/my/register.php"
//参数?username=%@&password=%@&email=%@


//注册接口类型
#define REGISTER_TYPE 2

//上传头像(post)
#define kUploadImage @"http://10.0.8.8/sns/my/upload_headimage.php"
//获取相册列表(post)
#define kPhotoList @"http://10.0.8.8/sns/my/album_list.php"


#endif
