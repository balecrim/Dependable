//
//  DependencyResolver.swift
//  
//
//  Created by Bernardo Alecrim on 15/01/21.
//

import Foundation

public struct DependencyResolver {

    public static var current = DependencyResolver()

    private var registrationQueue = DispatchQueue(label: "dev.alecrim.dependencyRegistration",
                                                  attributes: .concurrent)


    private var dependencyContexts: [DependencyKey: DependencyContext] = [:]
    private var dependencyFactories: [DependencyKey: () -> Any] = [:]
    private var dependencyCache: [DependencyKey: Any] = [:]


    // MARK: - Registration

    /// Registers a factory method for a given type.
    /// - Parameters:
    ///   - factory: The factory method, erasing return type to Any.
    ///   - type: The actual type to which we can expect the fabricated instance to
    ///           conform.
    ///   - context: The resolution context to which we'll bind the type.
    public mutating func register<T>(factory: @escaping () -> Any,
                              for type: T.Type,
                              context: DependencyContext = .module) {

        let key = DependencyKey(type: type)

        registrationQueue.sync(flags: [.barrier]) {
            self.dependencyFactories[key] = factory
            self.dependencyContexts[key] = context
        }

    }

    // MARK: - Resolution

    /// Resolves an instance of a given registered type.
    /// - Parameter type: The type for which we'll attempt to resolve the instance.
    /// - Throws: A DependencyResolutionError in case we can't resolve the instance.
    /// - Returns: An instance of the requested type, according to the resolution context
    ///            given at registration type.
    public mutating func resolve<T>(for type: T.Type) throws -> T {

        let key = DependencyKey(type: type)

        var resolved: Any?

        try? registrationQueue.sync {
            guard let dependencyContext = self.dependencyContexts[key] else {
                throw DependencyResolutionError.noRegistrationForType
            }

            if dependencyContext == .module {
                resolved = self.resolveUsingCache(for: key) ?? self.resolveUsingFactory(for: key)
            } else {
                resolved = self.resolveUsingFactory(for: key)
            }
        }

        guard resolved != nil else {
            throw DependencyResolutionError.noInstanceResolvedForType
        }

        guard let resolvedTypeInstance = resolved as? T else {
            throw DependencyResolutionError.resolvedInstanceTypeMismatch
        }

        return resolvedTypeInstance

    }

    // MARK: - Resolution Helpers

    mutating private func resolveUsingCache(for key: DependencyKey) -> Any? {
        let dependency = dependencyCache[key] ?? dependencyFactories[key]?()

        registrationQueue.sync {
            self.dependencyCache[key] = dependency
        }

        return dependency
    }

    private func resolveUsingFactory(for key: DependencyKey) -> Any? {
        return dependencyFactories[key]?()
    }

    // MARK: - Cache Management

    /// Flushes the DependencyResolver instance cache.
    public mutating func flushInstanceCache() {
        self.dependencyCache = [:]
    }

}
