//
//  DependencyContext.swift
//  
//
//  Created by Bernardo Alecrim on 15/01/21.
//

import Foundation

public enum DependencyContext {
    /// Retains the first instance to be fabricated in a cache
    /// that is retained alongside the current DependencyResolver
    /// instance.
    case module

    /// Builds a new instance of the type whenever we try
    /// to resolve it.
    case retrieval
}
