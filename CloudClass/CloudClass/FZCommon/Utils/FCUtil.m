//
//  FCUtil.m
//  FunChat
//
//  Created by Feizhu Tech . on 15/5/28.
//  Copyright (c) 2015年 hanbingquan. All rights reserved.
//

#import "FCUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>


@implementation FCUtil

+ (NSString *)bundleShortVersionString
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (NSString *)bundleVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_buildVersion;
}

+ (NSString *)md5HexString:(NSString *)string
{
    if (!string || [string length] == 0) {
        return @"";
    }
    
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSString *)encodeBase64String:(NSString *)string
{
    if (!string || [string length] == 0) {
        return @"";
    }
    // Create NSData object
    NSData *nsdata = [string
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // return the Base64 encoded string
    return base64Encoded;
}

+ (NSString *)decodeBase64String:(NSString *)base64String
{
    if (!base64String || [base64String length] == 0) {
        return @"";
    }
    
    // NSData from the Base64 encoded str
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:base64String options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    
    return base64Decoded;
}

+ (CGFloat)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGRect)bounds
{
    return [[UIScreen mainScreen] bounds];
}

+ (NSString *)jsonStringWithString:(NSString *)string
{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+ (NSString *)jsonStringWithArray:(NSArray *)array
{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [FCUtil jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary
{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [FCUtil jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+ (NSString *)jsonStringWithObject:(id)object
{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [FCUtil jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [FCUtil jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [FCUtil jsonStringWithArray:object];
    }
    return value;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

+ (BOOL)isValidateMobilePhoneNumber:(NSString *)mobiePhoneNumber
{
    if (FCIsEmpty(mobiePhoneNumber)) {
        return NO;
    }
    
    if (![mobiePhoneNumber hasPrefix:@"1"]) {
        return NO;
    }
    
    if ([mobiePhoneNumber length] < 11) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isValidatePassword:(NSString *)password
{
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:password] == YES){
        return YES;
    }
    return NO;
}

+ (UIImage*)rotateImage:(UIImage *)image
{
    int kMaxResolution = 320; // Or whatever
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:         //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 时间处理

+ (NSString *)secondChangToDateString:(NSString *)dateStr {
    
    if (FCIsEmpty(dateStr)) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString *timeString=[dateFormatter stringFromDate:date];
    return timeString;
}

+ (NSString *)secondChangToMonthTimeString:(NSString *)dateStr
{
    if (FCIsEmpty(dateStr)) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd HH:mm";
    
    NSString *timeString=[dateFormatter stringFromDate:date];
    return timeString;
}

+ (NSString *)secondChangToDate:(NSString *)dateStr {
    
    if (FCIsEmpty(dateStr)) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * timeString=[dateFormatter stringFromDate:date];
    
    return timeString;
}

#pragma mark - 判断输入纯字母还是文字

+(BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(string.length > 0)
    {
        return NO;
        
    }
    return YES;
    
}

+ (BOOL)isPureLetterChacacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    
    if(string.length > 0)
    {
        return NO;
        
    }
    return YES;
    
}


#pragma mark -获得给定字符串的宽高

+ (CGRect)getRectwithString:(NSString *)string withFont:(CGFloat)font withWidth:(CGFloat)width
{
    CGRect rect=[string boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect;
}

+ (NSString *)IDFA {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId;
}


@end
