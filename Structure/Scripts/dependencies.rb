module Dependencies

  APP_DEPENDENCIES = [
     'PillarDependencyBase'
  ]

  SHARED_DEPENDENCIES = [
    'SnapKit'
  ].freeze

  # Pillars inside Sources/Pillars/* are all imported as app's denependency
  Dir.glob("Sources/**/*") do |folder_name|
    module_name = folder_name.split('/').last
    APP_DEPENDENCIES.append(module_name)
  end
end
