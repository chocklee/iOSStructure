//
//  RootContainer+InfraUI.swift
//  InfraUI
//
//  Created by Changhao Li on 2023/3/7.
//

import Foundation
import Infra

extension RootContainer {
    private static var infraUIKey: UInt8 = 0

    public static var infraUI: InfraUIContainerProtocol {
        return objc_getAssociatedObject(self, &infraUIKey) as! InfraUIContainerProtocol
    }

    public static func setupWithInfraUIContainer(_ container: InfraUIContainerProtocol) {
        objc_setAssociatedObject(self, &infraUIKey, container, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
