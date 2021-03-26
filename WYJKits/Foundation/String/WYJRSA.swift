//
//  WYJEncryption.swift
//  WYJKitDemo
//
//  Created by 祎 on 2021/3/24.
//  Copyright © 2021 祎. All rights reserved.
//

import Foundation
import SwiftyRSA


public enum PublicKeyTpye  {
    case base64(_ string: String)
    case data(_ data: Data)
    /// PEM file
    case pemNamed(_ string: String, bundle: Bundle)
    /// DER file
    case derNamed(_ string: String, bundle: Bundle)
}
public enum PrivateKeyTpye  {
    case base64(_ string: String)
    case data(_ data: Data)
    /// PEM file
    case pemNamed(_ string: String, bundle: Bundle)
    /// DER file
    case derNamed(_ string: String, bundle: Bundle)
}

public extension WYJProtocol where T == String {
    /// RSA加密
    /// - Parameter type: 密钥创建方式
    /// - Parameter padding: 填充方式
    /// - Returns: base64字符串
    func RSAEncrypt(_ type: PublicKeyTpye,_ padding: Padding = .PKCS1) -> String? {
        return RSAEncrypted(type, padding)?.base64String
    }
    
    /// RSA加密
    /// - Parameter type: 密钥创建方式
    /// - Parameter padding: 填充方式
    /// - Returns: EncryptedMessage
    func RSAEncrypted(_ publicKeyTpye: PublicKeyTpye,_ padding: Padding = .PKCS1) -> EncryptedMessage? {
        switch publicKeyTpye {
            case .base64(let string):
                guard let publicKey = try? PublicKey(base64Encoded: string) else {
                    return nil
                }
                return encrypted(publicKey, padding)
            case .data(let data):
                guard let publicKey = try? PublicKey(data: data) else {
                    return nil
                }
                return encrypted(publicKey, padding)
            case .pemNamed(let string,let bundle):
                guard let publicKey = try? PublicKey(pemNamed: string, in: bundle) else {
                    return nil
                }
                return encrypted(publicKey, padding)
            case .derNamed(let string,let bundle):
                guard let publicKey = try? PublicKey(derNamed: string, in: bundle) else {
                    return nil
                }
                return encrypted(publicKey, padding)
        }
    }
    
    /// RSA解密
    /// - Parameter type: 密钥创建方式
    /// - Parameter padding: 填充方式
    /// - Returns: base64String
    func RSADecrypt(_ privateKeyTpye: PrivateKeyTpye,_ padding: Padding = .PKCS1) -> String? {
        return try? RSADecrypted(privateKeyTpye, padding)?.string(encoding: .utf8)
    }
    
    /// RSA解密
    /// - Parameter type: 密钥创建方式
    /// - Parameter padding: 填充方式
    /// - Returns: ClearMessage
    func RSADecrypted(_ type: PrivateKeyTpye,_ padding: Padding = .PKCS1) -> ClearMessage? {
        switch type {
            case .base64(let string):
                guard let publicKey = try? PrivateKey(base64Encoded: string) else {
                    return nil
                }
                return decrypted(publicKey, padding)
            case .data(let data):
                guard let publicKey = try? PrivateKey(data: data) else {
                    return nil
                }
                return decrypted(publicKey, padding)
            case .pemNamed(let string,let bundle):
                guard let publicKey = try? PrivateKey(pemNamed: string, in: bundle) else {
                    return nil
                }
                return decrypted(publicKey, padding)
            case .derNamed(let string,let bundle):
                guard let publicKey = try? PrivateKey(derNamed: string, in: bundle) else {
                    return nil
                }
                return decrypted(publicKey, padding)
        }
    }
    
    ///加密
    fileprivate func encrypted(_ publicKey: PublicKey,_ padding: Padding = .PKCS1) -> EncryptedMessage? {
        guard let clear = try? ClearMessage(string: obj, using: .utf8) else {
            return nil
        }
        guard let encrypted = try? clear.encrypted(with: publicKey, padding: padding) else {
            return nil
        }
        return encrypted
    }
    
    ///解密
    fileprivate func decrypted(_ privateKey: PrivateKey,_ padding: Padding = .PKCS1) -> ClearMessage? {
        guard let encrypted = try? EncryptedMessage(base64Encoded: obj) else {
            return nil
        }
        guard let clear = try? encrypted.decrypted(with: privateKey, padding: padding) else {
            return nil
        }
        return clear
    }
}
