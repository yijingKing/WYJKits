// RSA.h
//Create by chen liqun
// Date 2014.10.13
//


#import <Foundation/Foundation.h>

typedef void (^GenerateSuccessBlock)(void);

@interface RSA: NSObject{
@private
    NSData * publicTag;
	NSData * privateTag;
    NSOperationQueue * cryptoQueue;
    GenerateSuccessBlock success;
}

@property (nonatomic,readonly) SecKeyRef publicKeyRef;
@property (nonatomic,readonly) SecKeyRef privateKeyRef;
@property (nonatomic,readonly) NSData   *publicKeyBits;
@property (nonatomic,readonly) NSData   *privateKeyBits;


+ (id)shareInstance;
- (void)generateKeyPairRSACompleteBlock:(GenerateSuccessBlock)_success;

- (BOOL)generatePublicKeyByLocal_CER:(NSString*) cerFileName SecPaddingType:(SecPadding) secType;

- (NSData *)RSA_EncryptUsingPublicKeyWithData:(NSData *)data;
- (NSData *)RSA_EncryptUsingPrivateKeyWithData:(NSData*)data;
- (NSData *)RSA_DecryptUsingPublicKeyWithData:(NSData *)data;
- (NSData *)RSA_DecryptUsingPrivateKeyWithData:(NSData*)data;


-(NSData *)dataWithBase64EncodedString:(NSString *)string;

@property(nonatomic, assign) SecPadding secPaddingType;



// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;

// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;


@end
