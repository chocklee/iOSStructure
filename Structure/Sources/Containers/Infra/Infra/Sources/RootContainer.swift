//
//  RootContainer.swift
//  Infra
//
//  Created by Changhao Li on 2023/3/7.
//

import Foundation
import ObjectiveC

public final class RootContainer {

    private static var infraKey: UInt8 = 0

    public static var infra: InfraContainerProtocol {
        return objc_getAssociatedObject(self, &infraKey) as! InfraContainerProtocol
    }

    public static func setupWithInfraContainer(_ container: InfraContainerProtocol) {
        objc_setAssociatedObject(self, &infraKey, container, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

