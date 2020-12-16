/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import CoreGraphics

//MARK: --- NSAttributedString
public func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let ns = NSMutableAttributedString(attributedString: left)
    ns.append(right)
    return ns
}
//MARK: --- Dictionary
public func + <Key, Value>(left: [Key: Value], right: [Key: Value]) -> [Key: Value]{
    var result:[Key: Value] = left
    for (key,value) in right {
        result[key] = value
    }
    return result
}
//MARK: --- CGPoint
public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func += (lhs: inout CGPoint, rhs: CGPoint) {
    lhs = lhs + rhs
}
public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
public func -= (lhs: inout CGPoint, rhs: CGPoint) {
    lhs = lhs - rhs
}
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
public func *= (point: inout CGPoint, scalar: CGFloat) {
    point = point * scalar
}
public func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

//MARK: --- CGSize
public func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}
public func + (lhs: CGSize, tuple: (width: CGFloat, height: CGFloat)) -> CGSize {
    return CGSize(width: lhs.width + tuple.width, height: lhs.height + tuple.height)
}
public func += (lhs: inout CGSize, rhs: CGSize) {
    lhs.width += rhs.width
    lhs.height += rhs.height
}
public func += (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
    lhs.width += tuple.width
    lhs.height += tuple.height
}
public func - (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
}
public func - (lhs: CGSize, tuple: (width: CGFloat, heoght: CGFloat)) -> CGSize {
    return CGSize(width: lhs.width - tuple.width, height: lhs.height - tuple.heoght)
}
public func -= (lhs: inout CGSize, rhs: CGSize) {
    lhs.width -= rhs.width
    lhs.height -= rhs.height
}
public func -= (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
    lhs.width -= tuple.width
    lhs.height -= tuple.height
}
public func * (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
}
public func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: lhs.width * scalar, height: lhs.height * scalar)
}
public func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
    return CGSize(width: scalar * rhs.width, height: scalar * rhs.height)
}
public func *= (lhs: inout CGSize, rhs: CGSize) {
    lhs.width *= rhs.width
    lhs.height *= rhs.height
}
public func *= (lhs: inout CGSize, scalar: CGFloat) {
    lhs.width *= scalar
    lhs.height *= scalar
}
//MARK: --- CGVector
public func * (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}
public func * (scalar: CGFloat, vector: CGVector) -> CGVector {
    return CGVector(dx: scalar * vector.dx, dy: scalar * vector.dy)
}
public func *= (vector: inout CGVector, scalar: CGFloat) {
    // swiftlint:disable:next shorthand_operator
    vector = vector * scalar
}
public prefix func - (vector: CGVector) -> CGVector {
    return CGVector(dx: -vector.dx, dy: -vector.dy)
}

//MARK: --- Int
public func + (lhs: CGFloat,rhs: Int) -> CGFloat {
    
    let newRhs = CGFloat(rhs)
    return lhs + newRhs
}
public func - (lhs: CGFloat,rhs: Int) -> CGFloat {
    let newRhs = CGFloat(rhs)
    return lhs - newRhs
}
public func * (lhs: CGFloat,rhs: Int) -> CGFloat {
    let newRhs = CGFloat(rhs)
    return lhs * newRhs
}
public func / (lhs: CGFloat,rhs: Int) -> CGFloat {
    let newRhs = CGFloat(rhs)
    return lhs / newRhs
}
public func += (lhs: inout CGFloat,rhs: Int) {
    let newRhs = CGFloat(rhs)
    lhs = lhs + newRhs
}
public func -= (lhs: inout CGFloat,rhs: Int) {
    let newRhs = CGFloat(rhs)
    lhs = lhs - newRhs
}
public func *= (lhs: inout CGFloat,rhs: Int) {
    let newRhs = CGFloat(rhs)
    lhs = lhs * newRhs
}
public func /= (lhs: inout CGFloat,rhs: Int) {
    let newRhs = CGFloat(rhs)
    lhs = lhs / newRhs
}

public func + (lhs: Float,rhs: Int) -> Float {
    
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    return newLhs.adding(newRhs).floatValue
}
public func - (lhs: Float,rhs: Int) -> Float {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    return newLhs.subtracting(newRhs).floatValue
}
public func * (lhs: Float,rhs: Int) -> Float {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    return newLhs.multiplying(by: newRhs).floatValue
}
public func / (lhs: Float,rhs: Int) -> Float {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    return newLhs.dividing(by: newRhs).floatValue
}
public func += (lhs: inout Float,rhs: Int) {
    
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    lhs = newLhs.adding(newRhs).floatValue
}
public func -= (lhs: inout Float,rhs: Int) {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    lhs = newLhs.subtracting(newRhs).floatValue
}
public func *= (lhs: inout Float,rhs: Int) {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    lhs = newLhs.dividing(by: newRhs).floatValue
}
public func /= (lhs: inout Float,rhs: Int) {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    lhs = newLhs.dividing(by: newRhs).floatValue
}

public func + (lhs: Double,rhs: Int) -> Double {
    
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    return newLhs.adding(newRhs).doubleValue
}
public func - (lhs: Double,rhs: Int) -> Double {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    return newLhs.subtracting(newRhs).doubleValue
}
public func * (lhs: Double,rhs: Int) -> Double {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    return newLhs.multiplying(by: newRhs).doubleValue
}
public func / (lhs: Double,rhs: Int) -> Double {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    return newLhs.dividing(by: newRhs).doubleValue
}
public func += (lhs: inout Double,rhs: Int) {
    
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    lhs = newLhs.adding(newRhs).doubleValue
}
public func -= (lhs: inout Double,rhs: Int) {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    lhs = newLhs.subtracting(newRhs).doubleValue
}
public func *= (lhs: inout Double,rhs: Int) {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    lhs = newLhs.dividing(by: newRhs).doubleValue
}
public func /= (lhs: inout Double,rhs: Int) {
    let newLhs = NSDecimalNumber.init(string: String(format: "%f", lhs))
    let newRhs = NSDecimalNumber.init(string: String(format: "%ld", rhs))
    
    lhs = newLhs.dividing(by: newRhs).doubleValue
}
