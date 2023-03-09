//
//  InfraContainer.swift
//  Structure
//
//  Created by Changhao Li on 2023/3/7.
//

import Foundation
import Infra

open class InfraContainer: InfraContainerProtocol {

    open private(set) lazy var buildInfo = BuildInfo()
}
