//
//  ALISCLocalization.m
//  MCLocalization
//
//  Created by joy on 15/3/11.
//  Copyright (c) 2015年 MobileCreators. All rights reserved.
//

#import "FZLocalization.h"
#import "MCLocalization.h"

#define placeholderString @"{{value}}"

@implementation FZLocalization
//设置copy
+ (NSString *)stringForKey:(NSString *)key
{
    NSString * result = [MCLocalization stringForKey:key];
    
    if (!result) {
        NSString * s=[NSString stringWithFormat:@"no string for key %@ in language %@",key,[MCLocalization sharedInstance].language];
        result=s;
    }
    return result;
}

+ (NSString *)stringForKey:(NSString *)key withPlaceholders:(NSDictionary *)placeholders
{
    //重新设置下,把非NSString的转换为NSString
    __block NSString * result = [self stringForKey:key];
    [placeholders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if (![key isKindOfClass:NSString.class] || ![obj isKindOfClass:NSString.class]) {
            key=[NSString stringWithFormat:@"%@",key];
            obj=[NSString stringWithFormat:@"%@",obj];
        }
        result = [result stringByReplacingOccurrencesOfString:key withString:obj];

    }];
    return result;
}
//初始化语言文件
//后续这个类加入语言下载，格式也可以修改
+(void)loadLanguageFiles
{

    NSMutableDictionary *languageURLPairs=[NSMutableDictionary dictionaryWithCapacity:1];
    for (NSString * languageAbbreviation in [self getSupportedLanguages]) {
        NSString * fileName=[NSString stringWithFormat:@"%@.json",languageAbbreviation];
        [languageURLPairs setValue:[[NSBundle mainBundle] URLForResource:fileName withExtension:nil] forKey:languageAbbreviation];
    }
    
    [MCLocalization loadFromLanguageURLPairs:languageURLPairs defaultLanguage:[self getFileNameWithLanguage:CHINA]];
    
    [MCLocalization sharedInstance].noKeyPlaceholder = nil;
    
}

//切换语言
+(void)switchToLanguage:(NSString*)language
{
    [MCLocalization sharedInstance].language = language;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:ALISCLocalizationLanguageDidChangeNotification object:nil]];

}
+(NSString*)getCurrentLanguage
{
    return [MCLocalization sharedInstance].language;
}
+(NSArray*)getSupportedLanguages
{
    return @[@"ch"];
}

+(NSString*)getFileNameWithLanguage:(ALISCLANGUAGEENUM)language
{
    NSString * jsonFileName=@"";
    switch (language) {
        case CHINA:
            jsonFileName=@"ch";
            break;
        case SPANISH:
            jsonFileName=@"es";
            break;
        default:
            break;
    }
    return jsonFileName;
}

+(NSString*)getCurrentLanguageAbbreviationForServer
{
    NSDictionary * dic=@{@"en":@"EN",@"es":@"ES"};
    
    NSString * language = [dic objectForKey:[MCLocalization sharedInstance].language];
    
    if (!language) {
        return @"EN";
    }
    return language;
}
+(NSString*)getCurrentLanguageForBops
{
    NSDictionary * dic=@{@"en":@"english",@"es":@"spanish"};
    NSString * language = [dic objectForKey:[MCLocalization sharedInstance].language];
    
    if (!language) {
        return @"EN";
    }
    return language;
}
@end
