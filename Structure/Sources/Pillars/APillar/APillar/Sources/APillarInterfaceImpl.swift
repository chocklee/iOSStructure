//
//  APillarInterfaceImpl.swift
//  APillar
//
//  Created by Changhao Li on 2023/3/7.
//

import Foundation
import PillarDependencyBase

public class APillarInterfaceImpl: APillarInterface {

    public let openA: OpenAProtocol

    public init() {
        self.openA = OpenA()
    }
}
