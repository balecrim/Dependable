//
//  Injected.swift
//  
//
//  Created by Bernardo Alecrim on 15/01/21.
//

import Foundation

@propertyWrapper
public struct Injected<Dependency>{

    var component: Dependency

    public init(){
        guard let resolved = try? DependencyResolver.current.resolve(for: Dependency.self) else {
            fatalError("Failed to resolve instance for type \(String(describing: Dependency.self))")
        }

        self.component = resolved
    }

    public var wrappedValue: Dependency {
        get {
            return component
        }
        mutating set {
            component = newValue
        }
    }

}
