//
//  WYJEncryption.swift
//  WYJKitDemo
//
//  Created by 祎 on 2021/3/24.
//  Copyright © 2021 祎. All rights reserved.
//

import Foundation
import SwiftyRSA

public extension WYJProtocol where T == String {
    /// RSA加密
    /// - Parameter publicKeyBase64: 密钥base64字符串
    /// - Parameter padding: 填充方式
    /// - Returns: base64字符串
    func RSAEncrypted(publicKeyBase64: String,_ padding: Padding = .PKCS1) -> String? {
        
        guard let publicKey = try? PublicKey(base64Encoded: publicKeyBase64) else {
            return nil
        }
        guard let clear = try? ClearMessage(string: obj, using: .utf8) else {
            return nil
        }
        guard let encrypted = try? clear.encrypted(with: publicKey, padding: padding) else {
            return nil
        }
        return encrypted.base64String
    }
    
    /// RSA加密
    /// - Parameter keyBase64: 密钥base64字符串
    /// - Parameter padding: 填充方式
    /// - Returns: data
    func RSAEncryption(keyBase64: String,_ padding: Padding = .PKCS1) -> Data? {
        guard let publicKey = try? PublicKey(base64Encoded: keyBase64) else {
            return nil
        }
        guard let clear = try? ClearMessage(string: obj, using: .utf8) else {
            return nil
        }
        guard let encrypted = try? clear.encrypted(with: publicKey, padding: padding) else {
            return nil
        }
        return encrypted.data
    }
    
    /// RSA解密
    /// - Parameter privateBase64: 密钥base64字符串
    /// - Parameter padding: 填充方式
    /// - Returns: 字符串
    func RSADecrypted(privateBase64: String,_ padding: Padding = .PKCS1) -> String? {
        guard let privateKey = try? PrivateKey(base64Encoded: privateBase64) else {
            return nil
        }
        guard let encrypted = try? EncryptedMessage(base64Encoded: obj) else {
            return nil
        }
        guard let clear = try? encrypted.decrypted(with: privateKey, padding: padding) else {
            return nil
        }
        guard let result = try? clear.string(encoding: .utf8) else {
            return nil
        }
        return result
    }
    
    /// RSA解密
    /// - Parameter base64: 密钥base64字符串
    /// - Parameter padding: 填充方式
    /// - Returns: data
    func RSADecrypted(base64: String,_ padding: Padding = .PKCS1) -> Data? {
        guard let privateKey = try? PrivateKey(base64Encoded: base64) else {
            return nil
        }
        guard let encrypted = try? EncryptedMessage(base64Encoded: obj) else {
            return nil
        }
        guard let clear = try? encrypted.decrypted(with: privateKey, padding: padding) else {
            return nil
        }
        return clear.data
    }
}
