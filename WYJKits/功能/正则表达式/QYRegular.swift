/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import UIKit

///正则表达式
open class QYRegular: NSObject {
    public enum QYValidatedType {
        case Email
        case PhoneNumber
        case Number
        case SpecificNumbers
        case Chinese
        case IllegalCharacter
        case URL
        case BlankLines
        case QQ
        case ID
        case MAC
        case IdCard
        case DateInformation
        case AccountLegal
        case Password
        case StrongPassword
        case ThereIsNo
    }

    ///验证邮箱
    public class func yi_isEmail(_ vStr: String) -> Bool {
        return validateText(.Email, vStr)
    }

    ///验证手机号
    public class func yi_isPhoneNumber(_ vStr: String) -> Bool {
        return validateText(.PhoneNumber, vStr)
    }

    ///验证纯数字
    public class func yi_isNumber(_ vStr: String) -> Bool {
        return validateText(.Number, vStr)
    }

    ///验证数字个数
    public class func yi_isSpecificNumbers(_ vStr: String,_ num: Int) -> Bool {
        return validateText(.SpecificNumbers, vStr,num)
    }

    ///验证是否是中文
    public class func yi_isChinese(_ vStr: String) -> Bool {
        return validateText(.Chinese, vStr)
    }

    ///验证是否含有^%&',;=?$\"等字符
    public class func yi_isIllegalCharacter(_ vStr: String) -> Bool {
        return validateText(.IllegalCharacter, vStr)
    }

    ///验证URL
    public class func yi_isURL(_ vStr: String) -> Bool {
        return validateText(.URL, vStr)
    }

    ///验证首尾空白行
    public class func yi_isBlankLines(_ vStr: String) -> Bool {
        return validateText(.BlankLines, vStr)
    }

    ///验证QQ号
    public class func yi_isQQ(_ vStr: String) -> Bool {
        return validateText(.QQ, vStr)
    }

    ///验证ID地址
    public class func yi_isID(_ vStr: String) -> Bool {
        return validateText(.ID, vStr)
    }

    ///验证MAC地址
    public class func yi_isMAC(_ vStr: String) -> Bool {
        return validateText(.MAC, vStr)
    }

    ///验证身份证号
    public class func yi_isIdCard(_ vStr: String) -> Bool {
        return validateText(.IdCard, vStr)
    }

    ///验证年月日    例子 2013-04-1 2
    public class func yi_isDateInformation(_ vStr: String) -> Bool {
        return validateText(.DateInformation, vStr)
    }

    ///验证帐号是否合法(字母开头，默认允许6-18字节，允许字母数字下划线)
    public class func yi_isAccountLegal(_ vStr: String,
                                 _ num: Int? = nil,
                                 _ num2: Int? = nil) -> Bool {
        return validateText(.AccountLegal, vStr,num,num2)
    }
    ///验证密码(以字母开头，默认长度在6~18之间，只能包含字母、数字和下划线)
    public class func yi_isPasswordIsValidated(_ vStr: String,
                                        _ num: Int? = nil,
                                        _ num2: Int? = nil) -> Bool {
        return validateText(.Password, vStr)
    }
    ///验证强密码(必须包含大小写字母和数字的组合，不能使用特殊字符，长度在8-18之间)
    public class func yi_isStrongPassword(_ vStr: String,
                                   _ num: Int? = nil,
                                   _ num2: Int? = nil) -> Bool {
        return validateText(.StrongPassword, vStr)
    }
    ///验证
    private class func validateText(_ type: QYValidatedType,
                              _ validateString: String,
                              _ num: Int? = nil,
                              _ num2: Int? = nil) -> Bool {
        do {
            let pattern: String
            
            switch type {
                
            case .Email:
                pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
                
            case .PhoneNumber:
                pattern = "^1[0-9]{10}$"
                
            case .Number:
                pattern = "^[0-9]*$"
                
            case .SpecificNumbers:
                pattern = "^\\d{\(num ?? 6)}$"
                
            case .Chinese:
                pattern = "^[\\u4e00-\\u9fa5]{0,}$"
                
            case .IllegalCharacter:
                pattern = "[%&',;=?$\\\\^]+"
                
            case .URL:
                pattern = "^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$"
                
            case .BlankLines:
                pattern = "^s*|s*$"
                
            case .QQ:
                pattern = "[1-9][0-9]{4,}"
                
            case .ID:
                pattern = "([1-9]{1,3}\\.){3}[1-9]"
                
            case .MAC:
                pattern = "([A-Fa-f0-9]{2}\\:){5}[A-Fa-f0-9]"
                
            case .IdCard:
                pattern = "\\d{14}[[0-9],0-9xX]"
                
            case .DateInformation:
                pattern = "^\\d{4}-\\d{1,2}-\\d{1,2}"
                
            case .AccountLegal:
                pattern = "^[a-zA-Z][a-zA-Z0-9_]{\(num ?? 6),\(num2 ?? 18)}$"
                
            case .Password:
                pattern = "^[a-zA-Z]\\w{\(num ?? 6),\(num2 ?? 18)}$"
                
            case .StrongPassword:
                pattern = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{\(num ?? 6),\(num2 ?? 18)}$"
                
            default:
                pattern = ""
            }
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
}

