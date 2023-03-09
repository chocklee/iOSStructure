import pathlib

class TemplateTarget:

    isGraphQL = False
    targetName = ""
    targetLixContainerName = ""
    targetLixContainerVariableName = ""
    rootPath = pathlib.Path("")
    modulePath = pathlib.Path("")
    targetPath = pathlib.Path("")

    def __init__(self, modulePath: pathlib.Path, targetName: str, rootPath, isGrpahQLTarget = False):
        self.targetLixContainerVariableName = targetName
        if targetName[0].islower():
            targetName = targetName[0].upper() + targetName[1:]
        else:
            self.targetLixContainerVariableName = targetName[0].lower() + targetName[1:]
        self.targetName = targetName
        self.targetLixContainerName = f"{targetName}LixContainer"
        self.rootPath = rootPath
        self.modulePath = modulePath
        self.isGraphQL = isGrpahQLTarget
        self.targetPath = modulePath.joinpath(self.targetName)

    def podspec(self):
        sources = "'Sources/GeneratedGraphQLClient/*.{h,m}'" if self.isGraphQL else "'Sources/**/*.swift'"
        dependency = """
  s.dependency 'InfraLegacy'
  s.dependency 'KarposDataModel'
""" if self.isGraphQL else """
#   s.dependency 'InfraLegacy'
#   s.dependency 'InfraUILegacy'
#   s.dependency 'InfraUISwift'
#   s.dependency 'InfraSwift'
  s.dependency 'InfraAPI'
  s.dependency 'InfraUIAPI'
  s.dependency 'LixLib'
  s.dependency 'PillarDependencyBase'
"""
        return f"""Pod::Spec.new do |s|
  s.name = "{self.targetName}"
  s.requires_arc = true
  s.platform = :ios, "13.0"
  s.swift_version = '5.0'
  s.license = 'PRIVATE'
  s.author = 'KARPOS_POD_MANAGEMENT'
  s.homepage = 'http://www.linkedin.com'
  s.summary = 'summary'
  s.source = {{ :path => '.' }}
  s.source_files = {sources}, 'fix_project_structure'

{dependency}

  s.frameworks = 'Foundation', 'UIKit'
  s.version = "1.0.0"
  s.pod_target_xcconfig = {{
    'FRAMEWORK_SEARCH_PATHS' => '',
    'GCC_TREAT_WARNINGS_AS_ERRORS' => 'YES'
  }}
end
"""

    def fixStructureContent(self):
        return """
// This file is aimed to reserve the  ’Sources‘ group in the pod project of Xcode.
// It should be located at the root directory of pod project(Same layer as the *.podspec file).
// Please do not remove it manually. It will be auto-removed from the pod project in Xcode at the phase of 'post_intergrate'.
"""

    def lixContainerContent(self):
        return f"""import Foundation
import InfraAPI

public class {self.targetLixContainerName}: LIXDefaultContainer {{
    //public var testLix: LixExperiment = LixExperiment(key: "karpos.client.pillar_name.key", defaultTreatment: "enabled")

    public override init() {{
    }}
}}

extension Lix {{
    static var {self.targetLixContainerVariableName}: {self.targetLixContainerName} {{
        //swiftlint:disable force_cast
        return InfraRootContainer.infra.lix.container(for: {self.targetLixContainerName}.self) as! {self.targetLixContainerName}
        //swiftlint:enable force_cast
    }}
}}
"""

    def a11yIDContent(self):
        return f"""import Foundation

public enum {self.targetName}A11yID {{
    // case a11yID
}}

// DO NOT EDIT BELOW

public extension {self.targetName}A11yID {{
    var value: String {{
        return "{self.targetName}_\(self)"
    }}

    func value(uniqueID: String?) -> String {{
        let generalValue = value

        guard let uniqueID = uniqueID else {{
            return generalValue
        }}
        return generalValue + "_" + uniqueID
    }}
}}
"""
    def routerPageRouterPath(self):
        return f"""
import Foundation

public enum {self.modulePath.name.capitalize()}PageRouterPath {{

}}
"""

    def activeLixContainer(self):
        def changeContainerHelper():
            containerHelperPath = self.rootPath.joinpath("KarposApp/Sources/KarposInfra/Dependencies/LixContainerHelper.swift")
            content = []
            with containerHelperPath.open(mode="r+") as file:
                targetSuffix = "//POD_MANAGEMENT_PLACEHOLDER\n"
                content = file.readlines()
                placeholder = ""
                placeHolderIndex = 0
                for i, line in enumerate(content):
                    if line.endswith(targetSuffix):
                        placeholder = line
                        placeHolderIndex = i
                        content[i] = line.replace(targetSuffix, self.targetLixContainerName + "()\n")
                        content[i-1] = content[i-1][:-1] + ",\n"
                        break
                content.insert(placeHolderIndex + 1, placeholder)
                content.insert(0, f"import {self.targetName}\n")
            with containerHelperPath.open(mode="w") as file:
                file.writelines(content)
        changeContainerHelper()

    def createTargetSpec(self):
        specPath = self.targetPath.joinpath(f"{self.targetName}.podspec")
        specPath.touch()
        with specPath.open(mode="+w") as f:
            f.write(self.podspec())

    def activeRouter(self):
        AppRouterFolderPath = self.rootPath.joinpath("Source/Pillars/InfraUI/InfraUISwift/Sources/AppRouter")
        AppRouterSwiftPath = AppRouterFolderPath.joinpath("AppRouter.swift")
        content = []
        res = []
        with AppRouterSwiftPath.open(mode="r+") as file:
            targetEnumSuffix = "//POD_MANAGEMENT_ROUTER_ENUM"
            targetVarSuffix = "//POD_MANAGEMENT_ROUTER_VAR"
            targetGetSuffix = "//POD_MANAGEMENT_ROUTER_GET"
            suffix = "DO_NOT_REMOVE"
            content = file.readlines()
            lowercaseFirstLetterModuleName = self.modulePath.name[0].lower() + self.modulePath.name[1:]
            uppercaseFirstLetterModuleName = self.modulePath.name.capitalize()
            for i, line in enumerate(content):
                strippedLine = line.lstrip()
                if strippedLine.startswith(targetEnumSuffix):
                    newline = line.replace(targetEnumSuffix, f"case {lowercaseFirstLetterModuleName}" + f"({uppercaseFirstLetterModuleName}PageRouterPath)")
                    newline = newline.replace(suffix, "")
                    res.append(newline)
                    res.append(line)
                elif strippedLine.startswith(targetVarSuffix):
                    newline = line.replace(targetVarSuffix, f"public var {lowercaseFirstLetterModuleName}Router: AppRouterProtocol?")
                    newline = newline.replace(suffix, "")
                    res.append(newline)
                    res.append(line)
                elif strippedLine.startswith(targetGetSuffix):
                    newline = line.replace(targetGetSuffix, f"case .{lowercaseFirstLetterModuleName}:\n\t\t\treturn {lowercaseFirstLetterModuleName}Router")
                    newline = newline.replace(suffix, "")
                    res.append(newline)
                    res.append(line)
                else:
                    res.append(line)
        with AppRouterSwiftPath.open(mode="w") as file:
            file.writelines(res)

    def createFixStructure(self):
        fixStructurePath = self.targetPath.joinpath("fix_project_structure")
        fixStructurePath.touch()
        with fixStructurePath.open(mode="+w") as f:
            f.write(self.fixStructureContent())
        print("fix_project_structure configured")

    def fillLix(self):
        sourcePath = self.targetPath.joinpath("Sources")
        lixPath = sourcePath.joinpath("Lix")
        if lixPath.exists():
            print("Lix folder exists, drop creating")
            return
        lixPath.mkdir()
        lixWrapperPath = lixPath.joinpath(f"{self.targetLixContainerName}.swift")
        lixWrapperPath.touch()
        with lixWrapperPath.open(mode="+w") as f:
            f.write(self.lixContainerContent())
        self.activeLixContainer()
        print("Lix configured")
        return self

    def fillA11yID(self):
        sourcePath = self.targetPath.joinpath("Sources")
        a11yIDPath = sourcePath.joinpath("A11yID")
        if a11yIDPath.exists():
            print("A11y folder exists, drop creating")
            return
        a11yIDPath.mkdir()
        a11yIDWrapperPath = a11yIDPath.joinpath(f"{self.targetName}A11yID.swift")
        a11yIDWrapperPath.touch()
        with a11yIDWrapperPath.open(mode="+w") as f:
            f.write(self.a11yIDContent())
        print("A11y configured")
        return self

    def fillAppRouter(self):
        AppRouterFolderPath = self.rootPath.joinpath("Source/Pillars/InfraUI/InfraUISwift/Sources/AppRouter")
        NewPillarRouterFolderPath = AppRouterFolderPath.joinpath(self.modulePath.name)
        if NewPillarRouterFolderPath.exists():
            print(f"AppRouter folder for new module {self.modulePath.name} exists, drop creating router")
            return
        else:
            NewPillarRouterFolderPath.mkdir()
        PillarRouterPath = NewPillarRouterFolderPath.joinpath(f"{self.modulePath.name.capitalize()}PageRoutePath.swift")
        PillarRouterPath.touch()
        with PillarRouterPath.open(mode="+w") as f:
            f.write(self.routerPageRouterPath())
        self.activeRouter()
        print("AppRouter configured")


    def createCommonContent(self):
        self.createTargetSpec()
        self.createFixStructure()
        sourcePath = self.targetPath.joinpath("Sources")
        sourcePath.mkdir()
        return self


class TemplateResourceTarget:

    targetName: str
    moduleName: str
    modulePath: pathlib.Path

    def podspec(self):
        return f"""
# See podspec rules at go/podspec-review-rules
Pod::Spec.new do |s|
  s.name = '{self.targetName}'
  s.requires_arc = true
  s.platform = :ios, "13.0"
  s.swift_version = '5.0'
  s.license = 'PRIVATE'
  s.author = 'LinkedIn'
  s.homepage = 'http://www.linkedin.com'
  s.summary = 'summary'
  s.source = {{ :path => '.' }}
  s.version = "1.0.0"

  s.source_files = '**/*.h'
  s.ios.resource_bundle = {{ '{self.moduleName}Resources' => [ 'Resources/**/*.lproj' ] }}
end
"""

    def __init__(self, moduleName, targetName, modulePath) -> None:
        self.moduleName = moduleName
        self.targetName = targetName
        self.modulePath = modulePath

    def createTargetSpec(self, modulePath):
        targetPath = modulePath.joinpath(self.targetName)
        specPath = targetPath.joinpath(f"{self.targetName}.podspec")
        specPath.touch()
        with specPath.open(mode="+w") as f:
            f.write(self.podspec())
        return targetPath

    def createResourceFiles(self, targetPath):
        resourcePath = targetPath.joinpath("Resources")
        resourcePath.mkdir()
        engPath = resourcePath.joinpath("en.lproj")
        engPath.mkdir()
        resPath = engPath.joinpath(f"{self.moduleName}.strings")
        resPath.touch()
        chnPath = resourcePath.joinpath("zh-Hans.lproj")
        chnPath.mkdir()
        resPath = chnPath.joinpath(f"{self.moduleName}.strings")
        resPath.touch()

    def fillContent(self):
        targetPath = self.createTargetSpec(self.modulePath)
        self.createResourceFiles(targetPath)
