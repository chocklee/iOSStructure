//
//  OpenB.swift
//  BPillar
//
//  Created by Changhao Li on 2023/3/7.
//

import Foundation
import PillarDependencyBase

public class OpenB {

    public init() {}

    public func appName() -> String {
        return PillarRootContainer.aPillar.openA.appName()
    }
}
