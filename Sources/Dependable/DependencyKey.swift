//
//  DependencyKey.swift
//  
//
//  Created by Bernardo Alecrim on 15/01/21.
//

import Foundation

public struct DependencyKey: Equatable, Hashable {

    let type: Any.Type

    public init(type: Any.Type) {
        self.type = type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }

    public static func ==(lhs: DependencyKey, rhs: DependencyKey) -> Bool {
        return lhs.type == rhs.type
    }

}
