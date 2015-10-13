//
//  SGCryptoUtil.h
//  SGPhoneCodeBase
//
//  Created by zhouql05 on 12-3-6.
//  Copyright (c) 2012年 Sogou. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * getMessageKey();

@interface NSData (SGCryptoUtil) 

-(NSData *) AES128EncryptWithKey128:(NSString *)key;
-(NSData *) AES128DecryptWithKey128:(NSString *)key;

@end

@interface SGCryptoUtil : NSObject

@property (nonatomic, retain) NSString *key;

+(SGCryptoUtil *)defaultUtil;
+(NSString *) defaultKey;

-(id)initWithKey: (NSString *)key;

-(void) encryptFile: (NSString *)srcFile toFile: (NSString *)targetFile;
-(void) decryptFile: (NSString *)srcFile toFile: (NSString *)targetFile;
-(void) encryptFilesInDir: (NSString *)srcDir toDir:(NSString *)targetDir;
-(void) decryptFilesInDir: (NSString *)srcDir toDir:(NSString *)targetDir;
-(NSData *) getDecryptData: (NSString *)srcFile;
-(NSData *) getEncryptData: (NSString *)srcFile;

-(NSData *) encryptData: (NSData *)data;
-(NSData *) decryptData: (NSData *)data;

@end
