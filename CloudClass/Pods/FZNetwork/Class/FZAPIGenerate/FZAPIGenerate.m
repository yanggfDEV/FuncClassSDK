//
//  FZAPIGenerate.m
//  Pods
//
//  Created by yanming.huym on 15/5/19.
//
//

#import "FZAPIGenerate.h"

const NSString* defaultNetworkHost =  @"api.ifunclass.com";
const NSString* defaultNetworkHostTest =@"apitest.ifunclass.com";

const NSString* defaultHttpsNetworkHost =  @"api.ifunclass.com";
const NSString* defaultHttpsNetworkHostTest = @"apitest.ifunclass.com";



const NSString* defaultBaseUrl = @"index.php";
const NSString* defaultModelApi = @"api";

static NSString* const apiFileName = @"FZCloudClassConfig";
static NSString* const apiFileExtension = @"json";


@implementation FZAPIGenerate
{
    NSDictionary * cachedDictionary;
}

+(NSDictionary*)apiDictionary
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:apiFileName ofType:apiFileExtension];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return dic;
}

+(FZAPIGenerate*)sharedInstance
{
    static FZAPIGenerate* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken,^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)defaultProtocol {
    if (!_defaultProtocol) {
        return @"https";
    }
    return _defaultProtocol;
}

-(NSString*)API:(NSString*)apiName
{
    NSDictionary* configDict = nil;
    if (!cachedDictionary) {
        configDict = [[self class] apiDictionary];
    }
    else {
        configDict = cachedDictionary;
    }
    
    NSDictionary *dic = [configDict objectForKey:apiName];
    NSString* apiProtocol = nil;
//    const NSString* host   = self.isTestMode ? defaultNetworkHostTest : defaultNetworkHost;
    const NSString *host = self.isTestMode ? defaultHttpsNetworkHostTest : defaultHttpsNetworkHost;

    //测试环境统一使用http
//    if (self.isTestMode) {
        apiProtocol = @"http";
//    }
//    else {
//        apiProtocol=[dic objectForKey:@"protocol"]?[dic objectForKey:@"protocol"]:@"https";
//        if ([apiProtocol isEqual:@"http"]) {
//            host   = self.isTestMode ? defaultHttpsNetworkHostTest : defaultHttpsNetworkHost;
//        }
//    }

    //拼接url
    NSString *apiUrl = [NSString stringWithFormat:@"%@://%@",apiProtocol,host];
    NSString *control = dic[@"control"];
    if (control && ![control isEqual:[NSNull null]]) {
        apiUrl = [apiUrl stringByAppendingFormat:@"/%@", control];
    }
    
    NSString *action = dic[@"action"];
    if (action && ![action isEqual:[NSNull null]]) {
        apiUrl = [apiUrl stringByAppendingFormat:@"/%@", action];
    }
    
    apiUrl = [apiUrl stringByAppendingString:@"?"];

    return apiUrl;
    
}

@end
