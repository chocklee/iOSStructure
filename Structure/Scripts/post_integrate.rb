require 'xcodeproj'

## Post intergrate hooks for Cocoapods
def postIntergrate(installer)

  # Fix up the Development Pods so they are easier to work with.
  # The following changes are made to any pod that contains a `fix_project_structure` file
  #  - Removes the (now redundant) `fix_project_structure` file
  #  - Moves each {target_name} group to the top
  #  - Moves each {target_name}/Sources group to the top
  # Note this script makes no functional changes to the pod so you should be able to comment out
  #   all of this script and have things continue to work just fine
  installer.generated_projects.each do |project|

    fix_files = project.files.select { |file| File.basename(file.path) == "fix_project_structure" }
    project_name = "#{File.basename(project.path, '.xcodeproj')}"
    next if fix_files.nil? || fix_files.empty? || project_name.nil?

    puts "#{project_name} -> #{project.path}"
    puts "  `fix_project_structure` file(s) FOUND"
    puts "  Removing `fix_project_structure` file(s) from project entirely"
    fix_files.each do |fix_file|
      fix_file.remove_from_project
    end

    project.targets.reverse.each do |target|
        target_name = target.name
        target_group = project.groups.find.find { |group| group.to_s == target_name }
        next if target_group.nil?

        puts "      `#{target_name}` group FOUND"
        puts "          Moving `#{target_name}` group to top"
        project.main_group.children.delete(target_group)
        project.main_group.children.insert(0, target_group)

        sources_group = target_group.groups.find.find { |subgroup| subgroup.to_s == 'Sources' }
        if sources_group.nil? != true
            puts "          `#{target_name}/Sources` group FOUND"
            puts "          Moving `#{target_name}/Sources` group to top"
            target_group.children.delete(sources_group)
            target_group.children.insert(0, sources_group)
        end
    end
    project.save
  end

  # Remove Assets.car for project to support building with new build system.
  project_path = 'Structure.xcodeproj'
  project = Xcodeproj::Project.open(project_path)
  project.targets.each do |target|
      build_phase = target.build_phases.find { |bp| bp.display_name == '[CP] Copy Pods Resources' }
      assets_path = '${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/Assets.car'
      if build_phase.present? && build_phase.output_paths.include?(assets_path) == true
          build_phase.output_paths.delete(assets_path)
      end
  end
  project.save(project_path)
end
