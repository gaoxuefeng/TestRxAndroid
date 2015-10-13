//
//  SGCryptoUtil.m
//  SGPhoneCodeBase
//
//  Created by zhouql05 on 12-3-6.
//  Copyright (c) 2012年 Sogou. All rights reserved.
//

#import "SGCryptoUtil.h"
#import <CommonCrypto/CommonCryptor.h>

static NSString * messageKey = nil;

NSString * getMessageKey()
{
    // dAf#weJiu#RuqC#s
    
    if (messageKey == nil)
    {
        char s1[] = {'c' + 1, 'B' - 1, 'f', '\0'};
        char s2[] = {'v' + 1, 'f' - 1, 'I' + 1, 'h' + 1, 'v' - 1, '\0'};
        char s3[] = {'S' - 1, 't' + 1, 'p' + 1, 'D' - 1, '\0'};
        char s4[] = {'r' + 1, '\0'};
        
        messageKey = [[NSString stringWithFormat:@"%s#%s#%s#%s", s1, s2, s3, s4] retain];
    }
    return messageKey;
}

@implementation NSData (SGCryptoUtil) 

- (NSData *)AES128EncryptWithKey128:(NSString *)key {
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    memcpy(keyPtr, [key cStringUsingEncoding:NSUTF8StringEncoding], kCCKeySizeAES128);

    NSUInteger dataLength = [self length];
    NSUInteger inLen = dataLength;
    
    int residue = (int)(inLen % kCCBlockSizeAES128);
    if (residue != 0) 
    {
        inLen = inLen + (kCCBlockSizeAES128 - residue);
    }
    void *inBuffer = malloc(inLen);
    memcpy(inBuffer, [self bytes], dataLength);
    
    //不足kCCBlockSizeAES128, 用空格填充
    if (inLen > dataLength) 
        memset(inBuffer + dataLength, ' ', inLen - dataLength);
        
    size_t outLen = inLen + kCCBlockSizeAES128;
    void *outBuffer = malloc(outLen);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          /*kCCOptionPKCS7Padding | */
                                          kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          inBuffer, inLen,
                                          outBuffer, outLen,
                                          &numBytesEncrypted);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) 
    {
        result = [NSData dataWithBytes:outBuffer 
                                length:numBytesEncrypted];
    }
    free(inBuffer);
    free(outBuffer);
    
    return result;
}

- (NSData *)AES128DecryptWithKey128:(NSString *)key {
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    memcpy(keyPtr, [key cStringUsingEncoding:NSUTF8StringEncoding], kCCKeySizeAES128);
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          /*kCCOptionPKCS7Padding | */
                                          kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) 
    {
        //去掉末尾填充的空格
        while (numBytesDecrypted > 0
               && ((char *)buffer)[numBytesDecrypted - 1] == ' ')
        {
            --numBytesDecrypted;
        }
        if (numBytesDecrypted > 0)
        {
            result = [NSData dataWithBytes:buffer 
                                    length:numBytesDecrypted];
        }
    }
    free(buffer);
    return result;
}

@end

static NSString *_defaultKey = nil;

@implementation SGCryptoUtil

@synthesize key = _key;

+(SGCryptoUtil *)defaultUtil
{
    return [[[SGCryptoUtil alloc] init] autorelease];
}

+(NSString *) defaultKey
{
    @synchronized(self)
    {
        if (_defaultKey == nil) 
        {
//            char s1[] = {'R' + 1, 'p' - 1, 'g', 'n' + 1, 'u', '\0'};
//            char s2[] = {'I' - 1, 'c' - 2, 'o', 'l' + 1, 'b' - 1, '\0'};
//            char s3[] = {'T', 'q' - 2, 'm' + 1, 'i' - 2, '\0'};
            char s1[] = { 'R' + 1, 'i' - 1, 'o', 'v' + 1, 'N' - 1, 'a' + 4, 0 };
            char s2[] = { 'U' - 1, 'j' - 2, 'e', 0 };
            char s3[] = { 'M', 'q' - 2, 'm' + 1, 'g' - 2, 'z' - 1, 0 };
            _defaultKey = [[NSString stringWithFormat: @"%s$%s$%s", s1, s2, s3] retain];
        }
        return _defaultKey;
    }
}

-(NSString *) cryptoKey
{
    NSString *result = [SGCryptoUtil defaultKey];;
    if(self.key != nil)
        result = self.key;
    return result;
}

-(id)initWithKey:(NSString *)key
{
    if((self = [super init]) == nil)
        return nil;
    self.key = key;
    return self;
}

-(id)init
{
    return [self initWithKey:nil];
}

-(void)dealloc
{
    self.key = nil;
    [super dealloc];
}

-(void) checkDirExist:(NSString *)srcDir
{
    BOOL isDir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:srcDir isDirectory:&isDir] || !isDir)
    {
        [NSException raise:@"SGException" format:@"****: dir '[%@]' is not exist.", srcDir];
    }
}

-(void) checkFileExist:  (NSString *)srcFile
{
    BOOL isDir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:srcFile isDirectory:&isDir] || isDir)
    {
        [NSException raise:@"SGException" format:@"****: file '[%@]' is not exist.", srcFile];
    }
}

-(void) checkFileNotExist:(NSString *)srcFile
{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:srcFile isDirectory:&isDir] && !isDir)
    {
        [NSException raise:@"SGException" format:@"****: '[%@]' is a file.", srcFile];
    }
}

-(void) checkDirNotExist:(NSString *)srcDir
{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:srcDir isDirectory:&isDir] && isDir)
    {
        [NSException raise:@"SGException" format:@"****: '[%@]' is a dir.", srcDir];
    }
}

-(bool) isDir: (NSString *)srcFile
{
    BOOL isDir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:srcFile isDirectory:&isDir] || !isDir)
        return false;
    return true;
}

-(void) createDirIfNotExist: (NSString *)srcDir
{
    [self checkFileNotExist:srcDir];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:srcDir]) 
    {
        NSError *error;
        if(![fm createDirectoryAtPath:srcDir withIntermediateDirectories:YES attributes:nil error:&error])
        {
            [NSException raise:@"SGException" format:@"****: failed to create dir '[%@]'. Error info: %@", srcDir, error];
        }
    }
}

-(void) cryptFilesInDir:(NSString *)srcDir toDir:(NSString *)targetDir doEncryt: (bool) encrypt
{
    [self checkDirExist:srcDir];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err = nil;
    NSArray *files = [fm contentsOfDirectoryAtPath:srcDir error:&err];
    if (files == nil)
        return;
    
    if(targetDir == nil)
        targetDir = srcDir;
    
    [self createDirIfNotExist:targetDir];
    
    for (NSString *file in files) 
    {
        NSString *srcPath = [srcDir stringByAppendingPathComponent: file];
        NSString *targetPath = [targetDir stringByAppendingPathComponent:file];
        if([self isDir:srcPath])
        {
            [self cryptFilesInDir:srcPath toDir:targetPath doEncryt:encrypt];
        }
        else
        {
            if(encrypt)
            {
                [self encryptFile:srcPath toFile:targetPath];
            }
            else
            {
                [self decryptFile:srcPath toFile:targetPath];
            }
        }
    }
}

-(void) encryptFilesInDir: (NSString *)srcDir toDir:(NSString *)targetDir
{
    [self cryptFilesInDir:srcDir toDir:targetDir doEncryt:true];
}

-(void) decryptFilesInDir: (NSString *)srcDir toDir:(NSString *)targetDir
{
    [self cryptFilesInDir:srcDir toDir:targetDir doEncryt:false];
}

-(void) decryptFile: (NSString *)srcFile toFile: (NSString *)targetFile
{
    if(targetFile == nil)
        targetFile = srcFile;
    
    [self checkDirNotExist:targetFile];
    
    NSData *data = [self getDecryptData:srcFile];
    [data writeToFile:targetFile atomically:YES];
}

-(void) encryptFile: (NSString *)srcFile toFile: (NSString *)targetFile
{
    if(targetFile == nil)
        targetFile = srcFile;
    
    [self checkDirNotExist:targetFile];
    
    NSData *data = [self getEncryptData:srcFile];
    [data writeToFile:targetFile atomically:YES];
}

-(NSData *) getDecryptData: (NSString *)srcFile;
{
    [self checkFileExist:srcFile];
    NSData *data = [[NSData alloc] initWithContentsOfFile:srcFile];
    NSData *result = [self decryptData:data];
    [data release];
    return result;
}

-(NSData *) getEncryptData: (NSString *)srcFile
{
    [self checkFileExist:srcFile];
    NSData *data = [[NSData alloc] initWithContentsOfFile:srcFile];
    NSData *resultData =  [self encryptData: data];
    [data release];
    return resultData;
}

-(NSData *) encryptData: (NSData *)data
{
    return [data AES128EncryptWithKey128:[self cryptoKey]];   
}

-(NSData *) decryptData: (NSData *)data
{
    return [data AES128DecryptWithKey128:[self cryptoKey]];
}

@end
