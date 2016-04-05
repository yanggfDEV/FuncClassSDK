//
//  NSString+MBHMAC.h
//  MBHMAC
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

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NSString (Enhanced)

/**
 * @brief Generates a HMAC with a given key
 * @param algorithm The hashing algorithm that is going to be used to
 * create the HMAC:
 kCCHmacAlgSHA1,
 kCCHmacAlgMD5,
 kCCHmacAlgSHA256,
 kCCHmacAlgSHA384,
 kCCHmacAlgSHA512,
 kCCHmacAlgSHA224
 * @param keyString the secret key to be used to create the HMAC
 * @return The HMAC in base64 string format
 */
-(NSString *)hmacWithHashingAlgorithm:(CCHmacAlgorithm)algorithm
                                  key:(NSString *)keyString;

+ (NSString *)randomStringWithLength:(NSUInteger)len;

- (BOOL)containsString: (NSString*) substring;

//- (BOOL)seemsToBeEmail;

- (NSUInteger)lengthRespecting32BitCharacters; // the length of @"🌍" will be 2, but its lengthRespecting32BitCharacters will be one.

//判断string是nil或者""或者是[NSNull null]对象
- (BOOL)fz_isEmpty;

- (NSString *)MD5Hash;
- (NSString *)stringToTrimWhiteSpace;


@end
