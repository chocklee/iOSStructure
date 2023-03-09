Pod::Spec.new do |s|
  s.name = "App"
  s.requires_arc = true
  s.platform = :ios, '13.0'
  s.license = 'PRIVATE'
  s.author = 'Changhao Li'
  s.homepage = 'https://chocklee.github.io'
  s.summary = 'This pod contains all source files that would usually be included in the main app target. This has been separated out to allow other targets to access these sources without having to manually set the target membership on each file.'
  s.source = { :path => './' }
  s.version = "1.0.0"
  s.swift_version = '5.0'
  s.ios.deployment_target = '13.0'
  s.source_files = 'Sources/**/*.{swift}','fix_project_structure'

  source_podspecs = Dir.glob("../Sources/**/*.podspec")
  Dependencies::APP_DEPENDENCIES.flat_map { |folder_name| source_podspecs.filter {|s| s.include? "/#{folder_name}/"} }
    .flat_map { |file_name| File.basename(file_name, '.podspec') }
    .reject { |pod_name| pod_name.include? "Playground" }
    .each { |pod_name| s.dependency "#{pod_name}" }

  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$PODS_CONFIGURATION_BUILD_DIR'
  }

end
