//
//  PillarRootContainer.swift
//  PillarDependencyBase
//
//  Created by Changhao Li on 2023/3/7.
//

import Foundation

public protocol PillarInterface: AnyObject {

}

public struct PillarContainer {

    public var aPillar: APillarInterface
    public var bPillar: BPillarInterface
}

@dynamicMemberLookup
public final class PillarRootContainer: NSObject {

    static var container: PillarContainer!

    public static func setup(aPillar: APillarInterface,
                             bPillar: BPillarInterface) {
        container = PillarContainer(
            aPillar: aPillar,
            bPillar: bPillar)
    }

    public static subscript<T>(dynamicMember keyPath: WritableKeyPath<PillarContainer, T>) -> T {
        get { container[keyPath: keyPath] }
        set { container[keyPath: keyPath] = newValue }
    }
}
