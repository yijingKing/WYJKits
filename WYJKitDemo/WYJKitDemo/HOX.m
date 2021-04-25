//
//  HOX.m
//  WYJKitDemo
//
//  Created by 祎 on 2021/4/22.
//  Copyright © 2021 祎. All rights reserved.
//

#import "HOX.h"

@implementation HOX
-(unsigned char*)newByteArrayFromNSString:(NSString *)string
{
    char* chsField1 = (char*)[string cStringUsingEncoding:NSASCIIStringEncoding];
    //char* 2x -> char* 1x
    long len = 200;
    unsigned char* bysField1 = (unsigned char*) malloc(len);
    
    unsigned char data[3] = {0};
    for(int i = 0; i < len; i++) {
        memset(data, 0, sizeof(data));
        memcpy(data, &chsField1[i*2], 2);
        sscanf((const char*)data,"%x",(int*)&bysField1[i]);
    }
    return bysField1;
}
@end
