//
//  CommonMethod.m
//  LaiYiShou
//
//  Created by necsthz on 15-4-7.
//  Copyright (c) 2015年 liuxiaolong. All rights reserved.
//

#import "CommonMethod.h"
#import "sys/utsname.h"
#import <UIKit/UIKit.h>

#import <CommonCrypto/CommonDigest.h>

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

//#import "LoginVC.h"
#import "UIView+WLFrame.h"

#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface CommonMethod ()<UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *dismissView;

@end

@implementation CommonMethod

//***************************

//***************************

//判断设备类型
+ (DEVICETYPE)deviceType
{
    DEVICETYPE deviceType;
    NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 736) {
        deviceType = iPhone6Plus;
    } else if (screenHeight == 667) {
        deviceType = iPhone6;
    } else if (screenHeight == 568) {
        deviceType = iPhone5or5S;
    } else {
        deviceType = iPhone4or4S;
    }
    return deviceType;
}

//当前ios版本
+ (float)getIOSVersion {
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    return sysVersion;
}

//获取设备的UUID 并保存在共同变量UUID中
+(void)setUUID{
    // 取得设备id
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *deviceUID = [[device identifierForVendor] UUIDString];
   // NSLog(@"deviceUUID:%@",deviceUID); // 输出设备id
//    [Constant getInstance].uuid = deviceUID;
}

// 正则判断手机号码地址格式
+(BOOL)isMobileNumber:(NSString *)mobileNum
{

    if ([mobileNum length] != 11 || ([self isPureNumandCharacters:mobileNum] == NO)) {
        return NO;
    }
    else
    {
        return YES;
    }
}

// 正则判断邮箱
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//判断是否为纯数字
+(BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

// 移除字符串首尾空格
+ (NSString *)removeHeadAndFootSpaceWithString:(NSString *)string {
    
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


//判断是否为空字符串
+(BOOL)isBlankString:(NSString *)string {

    if (string == nil || string == NULL) {
        
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }

    return NO;
    
}
//判断如果字符串时空则转化成空字符串（防止出现空指针异常）
+(NSString *)changeStringNullToBlank:(NSString *)string {
    if ([self isBlankString:string]) {
        return @"";
    } else {
        return string;
    }
}

//md5加密方法(32位 加密 )
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

//保存图片
+(BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    BOOL result = NO;
    NSData* imageData = nil;
    if (UIImagePNGRepresentation(tempImage) == nil) {
        
        imageData = UIImageJPEGRepresentation(tempImage, 1);
        
    } else {
        
        imageData = UIImagePNGRepresentation(tempImage);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    if(imageData != nil)
    {
        [imageData writeToFile:fullPathToFile atomically:NO];
        result = YES;
    }
    else
    {
        result = NO;
    }
    return result;
}

//获取Documents
+(NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}



#pragma mark - 私有方法
//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSArray中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string
{
    return string;
}

//将Null类型的项目转化成@""
+(NSString *)nullToString
{
    return @"";
}

#pragma mark - 公有方法
//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}





#pragma mark - 点击图片放大预览图片
+ (void)showImage:(NSString *)imageUrl{
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;
//    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
//    backgroundView.backgroundColor=[UIColor blackColor];
//    backgroundView.alpha=0;
//    UIImageView *imageView=[[UIImageView alloc] init];
//    //[imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_Pic"]];
//    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
//        //NSLog(@"下载进度");
//    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        //NSLog(@"完成下载＝＝－－");
//        if (error) {
//        //NSLog(@"error is %@",error);
//        }else if (image) {
//            if (image.size.width > image.size.height) {
//                NSData  *tempData = UIImagePNGRepresentation(image);
//                CIImage * iImg = [CIImage imageWithData:tempData];
//                UIImage * tImg = [UIImage imageWithCIImage:iImg scale:1 orientation:UIImageOrientationRight];
//                imageView.frame =CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
//                imageView.image = tImg;
//            } else {
//                imageView.frame =CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
//                imageView.image = image;
//            }
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//        }
//    }];
//    
//    imageView.tag=1;
//    [backgroundView addSubview:imageView];
//    [window addSubview:backgroundView];
//    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
//    [backgroundView addGestureRecognizer: tap];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView.frame=CGRectMake(0,0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
//        backgroundView.alpha=1;
//    } completion:^(BOOL finished) {
//        
//    }];
}
+ (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_WIDTH);
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

//输入框设置左间隔
+ (void) setLeftViewInTextField: (UITextField *)textField{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(textField.frame))];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

//压缩图片
+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

//图片压缩成指定尺寸
+ (UIImage*)imageWithImageSimpleBySize:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

//图片安指定尺寸比率压缩图片 最小尺寸为100(宽或长的其中一个)
+ (UIImage*)imageWithImageSimpleByPercent:(UIImage*)image percent:(float)percent
{
    
    float minValue = 100.0f;
    float oldHeight = image.size.height;
    float oldWidth = image.size.width;
    float newHeight = oldHeight * percent;
    float newWidth = oldWidth * percent;
    
    //判断新的尺寸是否小于最小尺寸，小于的话，变成最小尺寸
    if (newHeight < minValue && newWidth < minValue) {
        //宽和高那个大
        if(newHeight >= newWidth){
            newHeight = minValue;   //高变100
            newWidth = minValue * oldWidth / oldHeight;
        } else {
            newWidth = minValue;    //宽边100
            newHeight = minValue * oldHeight / oldWidth;
        }
    }
    
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}




+ (void)alterWhithString:(NSString *)str
{
    UIAlertController *alterVC = [[UIAlertController alloc] init];
    UIAlertAction *action = [UIAlertAction actionWithTitle:str style:(UIAlertActionStyleDefault) handler:nil];
    [alterVC addAction:action];
    
}


#pragma mark - 判断字符串是否为空
+ (NSString *)judgeStringNull:(NSString *)str
{
    if (
        [str isEqualToString:@"null"] ||
        [str isKindOfClass:[NSNull class]] ||
        [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 ||
        str == nil ||
        str == NULL||
        [str isEqualToString:@"<null>"]) {
        return @"";
    } else {
        return str;
    }
}



+ (NSString *)getUUIDString

{
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
    
}


#pragma mark - 价格字符串保留两位小数
+ (NSString *)priceKeepTwoDecimalPlacesWithPrice:(NSString *)price
{
    // 先转成float
    float priceNum = [price floatValue];
    // 在格式化输出
    return [NSString stringWithFormat:@"%.2f", priceNum];
}




#pragma mark - 旋转图片
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}






#pragma mark -  自动消失提示框的 弹框
+ (void)showAlertAutoDismiss:(UIViewController *)mySelf msg:(NSString *)msg
{
    
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:msg  preferredStyle:(UIAlertControllerStyleAlert)];
        
        [mySelf presentViewController:alterVC animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alterVC dismissViewControllerAnimated:YES completion:nil];
        });

}


#pragma mark - 封装的创建label
+ (UILabel *)createLabel:(UILabel *)label whoViewAdd:(UIView *)view text:(NSString *)text fontSize:(CGFloat)fontSize frame:(CGRect)frame
{
    label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
   
//    label.backgroundColor = kMainColor;
//    label.alpha = 0.6;
    
    if (label) {
        
        if (view) {
            [view addSubview:label];
        }
        
        
    }
   //label.backgroundColor = [UIColor colorWithRed:0.181 green:1.000 blue:0.669 alpha:0.323];

    return label;
}

#pragma mark - 封装的创建textField
+ (UITextField *)createTextField:(UITextField *)textField whoViewAdd:(UIView *)view frame:(CGRect)frame  placehold:(NSString *)placehold
{
    textField = [[UITextField alloc] init];
    textField.placeholder = placehold;
    textField.frame = frame;
    textField.layer.borderColor = [UIColor colorWithRed:0.860 green:0.862 blue:0.895 alpha:1.000].CGColor;
    textField.font = [UIFont systemFontOfSize:14];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview:textField];
   // textField.backgroundColor = [UIColor colorWithRed:0.537 green:1.000 blue:0.061 alpha:1.000];
    return textField;
}

#pragma mark - 封装的button
+ (UIButton *)createButtonWithButton:(UIButton *)btn whoViewAdd:(UIView *)view title:(NSString *)title imageStr:(NSString *)imageStr fontSize:(CGFloat)fontSize frame:(CGRect)frame
{
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:imageStr] forState:(UIControlStateNormal)];
    [btn setTitle:title forState:(UIControlStateNormal)];

    [btn setBackgroundImage:[UIImage imageNamed:imageStr] forState:(UIControlStateNormal)];
  
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [view addSubview:btn];
    
    //btn.backgroundColor = kMainColor;
    
    return btn;
}

+ (UIButton *)ycreateButtonWithButton:(UIButton *)btn whoViewAdd:(UIView *)view title:(NSString *)title imageStr:(UIImage *)image fontSize:(CGFloat)fontSize frame:(CGRect)frame
{
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = frame;
    [btn setBackgroundImage:image forState:(UIControlStateNormal)];
    [btn setTitle:title forState:(UIControlStateNormal)];
    
    [btn setBackgroundImage:image forState:(UIControlStateNormal)];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [view addSubview:btn];
    return btn;
    
}
#pragma mark - UIImageView
+ (UIImageView *)createImageView:(UIImageView *)imageView whoViewAdd:(UIView *)view  frame:(CGRect)frame imageName:(NSString *)imageName
{
    imageView = [[UIImageView alloc] init];
    imageView.frame = frame;
    imageView.image = [UIImage imageNamed:imageName];
    [view addSubview:imageView];
    return imageView;
}


+ (UITextView *)createTextView:(UITextView *)textView whoViewAdd:(UIView *)view frame:(CGRect)frame  placehold:(NSString *)placehold
{
    textView = [[UITextView alloc] initWithFrame:frame];
    
    textView.layer.borderWidth = 1;
    //textView.layer.borderColor = kBorderColor_E8.CGColor;
    
    [view addSubview:textView];
    
    return textView;
}


+ (UIView *)createView:(UIView *)view whoViewAdd:(UIView *)superView frame:(CGRect)frame {
    view = [[UIView alloc] initWithFrame:frame];
    [superView addSubview:view];
    return view;
}






/// 给我一个字符串 我还你一个高度
+ (CGFloat)cellWithStr:(NSString *)str fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    
    // 计算字符串高度
    NSDictionary *dic = [NSDictionary  dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    // 宽度同label 一样大 高度绝对大
    CGRect frame = [str boundingRectWithSize:CGSizeMake(width, 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return frame.size.height+10;
}



+ (NSString *)timeIntervalStr:(NSString *)shijianCuo
{
    
//    NSDate *sss = [NSDate dateWithTimeIntervalSince1970:1458532335000];
    
//    
    NSDate *nowdata = [NSDate date];

    
    
    /// 求出现在的时间 距离 1970年的 秒数
    NSTimeInterval nowTimeInterval = [nowdata timeIntervalSince1970];

    //1458629408.4811349
    //1458532335000
    //1458625165
    [nowdata descriptionWithLocale:NSLocaleCountryCode];
    
    /// 现在的时间戳减去 接口中的时间戳, 就可以得出 多少分钟前
    NSTimeInterval time = nowTimeInterval - [shijianCuo longLongValue]/1000;//[shijianCuo doubleValue]/1000;//[shijianCuo doubleValue];

    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm:ss"];
    [format setTimeZone:GTMzone];

    NSString *str = [format stringFromDate:date];

    
 
    // 如果大于一天就显示 n天 HH mm ss
    if (time > 3600 * 24) {
        str = [NSString stringWithFormat:@"%d天%@",(int)time/3600/24, str];
    }

    return str;
    
   
    
    
//)_____________________
//     NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
//    
//     ;
//    
//    
//    return [self getTimeMinute:[NSString stringWithFormat:@"%lld",[timeSp longLongValue] - [shijianCuo longLongValue]/1000]];
    
}






+(NSString *)getTimeMinute:(NSString *)timeDate{
    
    
    NSTimeInterval time=[timeDate doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        
        return nil;
    } else {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    }
}


// *  objective-C不支持16进制的颜色表示，需要转换成rgb表示法
+( UIColor *) getColor:( NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range. length = 2 ;
    range. location = 0 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&red];
    range. location = 2 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&green];
    range. location = 4 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&blue];

    return [ UIColor colorWithRed :( float )(red/ 255.0f ) green :( float )(green/ 255.0f ) blue :( float )(blue/ 255.0f ) alpha : 1.0f ];
}



- (void)addToolBarForKeyBoard:(id)view
{
    //  自定义键盘
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard_Common)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [view setInputAccessoryView:topView];
    self.dismissView = view;
    [view resignFirstResponder];
}
-(void)dismissKeyBoard_Common
{
    [_dismissView resignFirstResponder];
}




+ (void)openCameraWithVC:(id)VC
{
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = VC;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [VC presentViewController:picker animated:YES completion:nil];
    }else {
        [CommonMethod showAlterMessage:@"该设备无摄像头"];
        
    }
   }
+ (void)selectLocalPhotoWithVC:(id)VC
{
   
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickVC.delegate = VC;
    pickVC.allowsEditing = YES;
    [VC presentViewController:pickVC animated:YES completion:nil];

}

+ (NSString *)dataStrFromTimeStamp:(NSString *)timeStamp
{
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}







/**
 *  比较两个日期的先后顺序
 *
 *  @param oneDay     时间1
 *  @param anotherDay 时间2
 *
 *  @return 1: 时间1是未来的时间;  返回-1:时间1是过去的时间;  返回0:两个时间相等
 */
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}



/**
 *  比较两个日期的先后顺序
 *  @param oneDateStr     时间1字符串
 *  @param anotherDateStr 时间2字符串
 *
 *  @return 1: 时间1是未来的时间;  返回-1:时间1是过去的时间;  返回0:两个时间相等
 */
+ (int)compareOneDateStr:(NSString *)oneDateStr withAnotherDateStr:(NSString *)anotherDateStr {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *oneDate = [dateFormat dateFromString:oneDateStr];
    NSDate *twoDate = [dateFormat dateFromString:anotherDateStr];
    NSComparisonResult result = [oneDate compare:twoDate];
    if (result == NSOrderedDescending) {
        return  1;
    } else if (result == NSOrderedAscending) {
        return -1;
    }
    return 0;
}






/*
 *分隔字符窜返回一个数组
 *
 */
+ (NSArray *)stringWithArray:(NSString *)string
{
    
    NSArray *array = [string componentsSeparatedByString:@","];
    return array;
}


//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


// 验证电话号码或者手机号
+ (BOOL)validPhoneNumOrTelphoneNum:(NSString *)phoneNum {
    
   
    
    if (phoneNum.length >=7 && phoneNum.length <= 12) {
        
        if ([self isPureNumandCharacters:phoneNum] == YES) {
            return YES;
        } else {
            return NO;
        }
        
        
    } else {
        return NO;
    }
}




// 根据字号 行间距 和 label宽度 来调节label的高度
+ (CGFloat)getSpaceLabelHeightWithStr:(NSString*)str withFontSize:(CGFloat)fontSize margin:(CGFloat)margin withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    /** 行高 */
    paraStyle.lineSpacing = margin;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paraStyle
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
// 清除document
+ (void)removeDocumentItemAtPath:(NSString *)path {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error = nil;
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        [fileManager removeItemAtPath:path error:&error];
       
        
    });
}




@end
