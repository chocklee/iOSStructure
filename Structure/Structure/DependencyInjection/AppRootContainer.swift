//
//  AppRootContainer.swift
//  Structure
//
//  Created by Changhao Li on 2023/3/7.
//

import Foundation
import Infra
import InfraUI
import PillarDependencyBase
import APillar
import BPillar

class AppRootContainer {

    static func setupForApp() {
        RootContainer.setupWithInfraContainer(InfraContainer())
        RootContainer.setupWithInfraUIContainer(InfraUIContainer())
        PillarRootContainer.setup(
            aPillar: APillarInterfaceImpl(),
            bPillar: BPillarInterfaceImpl())
    }
}
