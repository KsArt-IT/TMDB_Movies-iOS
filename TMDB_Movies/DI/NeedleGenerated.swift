

import Foundation
import NeedleFoundation
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class RepositoryDependency453d57de9749f65d685aProvider: RepositoryDependency {
    var repository: Repository {
        return rootComponent.repository
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->MainComponent
private func factory65f8ddecdd3fbdaceea4b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return RepositoryDependency453d57de9749f65d685aProvider(rootComponent: parent1(component) as! RootComponent)
}
private class RepositoryDependencyb171f3bdca6113e7a5d9Provider: RepositoryDependency {
    var repository: Repository {
        return rootComponent.repository
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->DetailComponent
private func factorybb31a88ab42162edbb0fb3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return RepositoryDependencyb171f3bdca6113e7a5d9Provider(rootComponent: parent1(component) as! RootComponent)
}

#else
extension MainComponent: Registration {
    public func registerItems() {
        keyPathToName[\RepositoryDependency.repository] = "repository-Repository"
    }
}
extension DetailComponent: Registration {
    public func registerItems() {
        keyPathToName[\RepositoryDependency.repository] = "repository-Repository"
    }
}
extension RootComponent: Registration {
    public func registerItems() {

        localTable["repository-Repository"] = { [unowned self] in self.repository as Any }
    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->RootComponent->MainComponent", factory65f8ddecdd3fbdaceea4b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->DetailComponent", factorybb31a88ab42162edbb0fb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
