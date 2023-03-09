Pod::Spec.new do |s|
  s.name = "APillar"
  s.requires_arc = true
  s.platform = :ios, "13.0"
  s.swift_version = '5.0'
  s.license = 'PRIVATE'
  s.author = 'Changhao Li'
  s.homepage = 'https://chocklee.github.io'
  s.summary = 'Karpos BPillar framework'
  s.source = { :path => './' }
  s.source_files = 'Sources/**/*.{swift}', 'fix_project_structure'

  s.dependency 'PillarDependencyBase'

  s.frameworks = 'Foundation', 'UIKit'
  s.version = "1.0.0"
  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '',
    'GCC_TREAT_WARNINGS_AS_ERRORS' => 'YES'
  }
end
