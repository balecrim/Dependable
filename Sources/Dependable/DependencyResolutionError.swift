//
//  DependencyResolutionError.swift
//  
//
//  Created by Bernardo Alecrim on 15/01/21.
//

import Foundation

public enum DependencyResolutionError: Error {
    /// Returned if we can't find a registration for a given type.
    case noRegistrationForType

    /// Returned if a type is registered but its factory method
    /// fails to materialize an instance.
    case noInstanceResolvedForType

    /// Returned in case we can resolve an instance, but in the
    /// we fail to cast it back to its registered type.
    case resolvedInstanceTypeMismatch
}
