
#import <Foundation/Foundation.h>

#define LOCALSTRING(x) [FZLocalization stringForKey:x]
#define LOCALSTRINGWithPlaceholder(x,placeholders) [FZLocalization stringForKey:x withPlaceholders:placeholders]
//#define LOCALSTRING(x) NSLocalizedString(x, nil)
#define ALISCLocalizationLanguageDidChangeNotification @"LocalizationLanguageDidSwitchNotification"

typedef enum{
    CHINA,
    ENGLISH,
    SPANISH,
    FRENCH,
    GERMAN,
    ITALIAN,
    ARABIC,
    PORTUGUESE,
    RUSSIAN,
    KOREAN,
    JAPANESE,
    TURKISH,
    THAI,
    HEBREW,
    VIETNAMESE,
    INDONESIAN
}ALISCLANGUAGEENUM;

@interface FZLocalization : NSObject
+ (NSString *)stringForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key withPlaceholders:(NSDictionary *)placeholders;
+(void)loadLanguageFiles;
+(void)switchToLanguage:(NSString*)language;
+(NSArray*)getSupportedLanguages;
+(NSString*)getCurrentLanguage;
/**
 *  根据当前语言获取服务端需要的语言简称
 *
 *
 *  @return 服务端需要的语言检查
 */
+(NSString*)getCurrentLanguageAbbreviationForServer;
/**
 *  根据当前的语言获取语言文件的地址
 *
 *  @param language 语言
 *
 *  @return 返回本地语言的文件名称
 */
+(NSString*)getFileNameWithLanguage:(ALISCLANGUAGEENUM)language;

/**
 *  用于获取动态文案的中bops对应的语言列表
 *
 *  @return 获取bops需要的语言内容
 */
+(NSString*)getCurrentLanguageForBops;

@end
