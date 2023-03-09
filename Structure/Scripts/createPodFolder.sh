#!/bin/bash

# Create the folder structure and empty podspec file for a given pod with module name and target name.
# The folder would be PROJ_ROOT/Sources/Pillars/MODULE_NAME/TARGET_NAME/, with TARGET_NAME.podspec and a folder named Sources/.
# Usage: ./scripts/createPodFolder.sh -m MODULE_NAME -t TARGET_NAME [--objc].

if [ $# -lt 4 ]; then
  echo "Illegal number of parameters."
  echo "Usage: './scripts/createPodFolder.sh -m MODULE_NAME -t TARGET_NAME' for Swift pod,"
  echo "or './scripts/createPodFolder.sh -m MODULE_NAME -t TARGET_NAME --objc' for Obj-C pod."
  exit 1
fi

source_files_type="swift"
language="Swift"

while [ $# -gt 0 ]; do
  case "$1" in
    -m)
      export module_name="${2}"
      shift
      ;;
    -t)
      export target_name="${2}"
      shift
      ;;
    --objc)
      export source_files_type="h,m"
      export language="Obj-C"
      ;;
    *)
      echo "Illegal argument."
      exit 1
  esac
  shift
done

mkdir -p Sources/Pillars/$module_name/$target_name/Sources

cat > Sources/Pillars/$module_name/$target_name/$target_name.podspec <<-EOF
Pod::Spec.new do |s|
  s.name = "$target_name"
  s.requires_arc = true
  s.platform = :ios, "13.0"
  s.swift_version = '5.0'
  s.license = 'PRIVATE'
  s.author = 'Changhao Li'
  s.homepage = 'https://chocklee.github.io'
  s.summary = 'Karpos ${target_name} framework'
  s.source = { :path => '.' }
  s.source_files = 'Sources/**/*.{$source_files_type}', 'fix_project_structure'

#  s.dependency 'InfraAPI'

  s.frameworks = 'Foundation', 'UIKit'
  s.version = "1.0.0"
  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$PODS_CONFIGURATION_BUILD_DIR',
    'GCC_TREAT_WARNINGS_AS_ERRORS' => 'YES'
  }
end
EOF

cat > Sources/Pillars/$module_name/$target_name/fix_project_structure <<-EOF
// This file is aimed to reserve the  ’Sources‘ group in the pod project of Xcode.
// It should be located at the root directory of pod project(Same layer as the *.podspec file).
// Please do not remove it manually. It will be auto-removed from the pod project in Xcode at the phase of 'post_intergrate'.
EOF

echo "Done for module: $module_name - target: $target_name in $language."
exit 0
