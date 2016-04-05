//
//  NSString+MBHMAC.m
//  MBHMAC
//
//
//  Created by Marcel Borsten on 5/21/13.
//  Copyright (c) 2013 Marcel Borsten All rights reserved.
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//#import <RegExCategories/RegExCategories.h>

#import "NSString+Enhanced.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Enhanced)

-(NSString *)hmacWithHashingAlgorithm:(CCHmacAlgorithm)algorithm
                                  key:(NSString *)keyString {
    int digestLength = [self lengthForAlgorithm:algorithm];
    const char *key = [keyString cStringUsingEncoding:NSUTF8StringEncoding];
    const char *data = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[digestLength];
    CCHmac(algorithm, key, strlen(key), data, strlen(data), cHMAC);
    NSMutableString *ret = [NSMutableString stringWithCapacity:digestLength*2];
    for (int i = 0; i<digestLength; i++) {
        [ret appendFormat:@"%02x", cHMAC[i]];
    }
    
    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return [HMACData base64EncodedStringWithOptions:0];
}

-(int)lengthForAlgorithm:(CCHmacAlgorithm)a {
    int length = 1;
    
    switch (a) {
        case kCCHmacAlgSHA1:
            length = CC_SHA1_DIGEST_LENGTH;
            break;
        case kCCHmacAlgMD5:
            length = CC_MD5_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA256:
            length = CC_SHA256_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA384:
            length = CC_SHA384_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA512:
            length = CC_SHA512_DIGEST_LENGTH;
            break;
    }
    return length;
}

static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

+ (NSString *)randomStringWithLength:(NSUInteger)len{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for(NSUInteger i = 0; i < len; i++){
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    return randomString;
}

- (BOOL) containsString: (NSString*) substring {
    NSRange range = [self rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}


//- (BOOL)seemsToBeEmail {
//    return [self isMatch:RX(@"^[A-Z0-9a-z._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$")];
//    
//}

- (NSUInteger)lengthRespecting32BitCharacters {
    return [self lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
}

- (BOOL)fz_isEmpty {
    if (self == (NSString *)[NSNull null] || self.length == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)MD5Hash {
    NSString *jsonString = self;
    const char *ptr = [jsonString UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, (uint32_t)strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

- (NSString *)stringToTrimWhiteSpace {
    NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    NSString *resultString = [self stringByTrimmingCharactersInSet:whitespace];
    if (resultString && resultString.length > 0) {
        return resultString;
    }
    
    return nil;
}

@end
