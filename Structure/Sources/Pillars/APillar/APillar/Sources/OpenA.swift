//
//  OpenA.swift
//  APillar
//
//  Created by Changhao Li on 2023/3/7.
//

import Foundation
import Infra
import PillarDependencyBase

class OpenA: OpenAProtocol {

    func appName() -> String {
        return RootContainer.infra.buildInfo.appName()
    }
}
