//
//  Operators.swift
//  Flickr
//
//  Created by Kautsya Kanu on 08/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import CoreGraphics

extension CGFloat{
    public init(_ value: CGFloat){
        self = value
    }
}

public protocol NumberConvertible: Comparable {
    init(_ value: Int)
    init(_ value: Float)
    init(_ value: Double)
    init(_ value: CGFloat)
}

extension NumberConvertible {
    fileprivate func convert<T: NumberConvertible>() -> T {
        switch self {
        case let x as CGFloat: return T(x)
        case let x as Float: return T(x)
        case let x as Int: return T(x)
        case let x as Double: return T(x)
        default:
            assert(false, "NumberConvertible convert cast failed!")
            return T(0)
        }
    }
    
    fileprivate typealias PreferredType = Double
    fileprivate typealias CombineType = (PreferredType,PreferredType) -> PreferredType
    fileprivate func operate<T:NumberConvertible,V:NumberConvertible>(_ b:T, combine:CombineType) -> V{
        let x:PreferredType = self.convert()
        let y:PreferredType = b.convert()
        return combine(x,y).convert()
    }
}

extension CGFloat : NumberConvertible {}
extension Double  : NumberConvertible {}
extension Float   : NumberConvertible {}
extension Int     : NumberConvertible {}

//MARK: - Assignment overloading -
public func * <T:NumberConvertible, U:NumberConvertible,V:NumberConvertible>(lhs: T, rhs: U) -> V {
    return lhs.operate(rhs, combine:*)
}

public func / <T:NumberConvertible, U:NumberConvertible,V:NumberConvertible>(lhs: T, rhs: U) -> V {
    return lhs.operate(rhs, combine:/)
}
