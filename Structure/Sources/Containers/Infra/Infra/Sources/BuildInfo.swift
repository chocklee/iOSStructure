//
//  BuildInfo.swift
//  Infra
//
//  Created by Changhao Li on 2023/3/7.
//

import Foundation

public class BuildInfo {

    public init() {}

    public func appName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
}
