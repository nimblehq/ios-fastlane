# frozen_string_literal: true

module VersioningModule
  def self.init(
    fastlane:,
    project_path:,
    main_target_name:
  )
    @@fastlane = fastlane
    @@project_path = project_path
    @@main_target_name = main_target_name
  end

  def self.build_number=(build_number)
    @@fastlane.increment_build_number(
      build_number: build_number,
      xcodeproj: @@project_path
    )
  end

  def self.build_number
    @@fastlane.get_build_number(xcodeproj: @@project_path)
  end

  def self.version_number
    @@fastlane.get_version_number(
      xcodeproj: @@project_path,
      target: @@main_target_name
    )
  end

  def self.version_number=(version_number)
    @@fastlane.increment_version_number(
      version_number: version_number,
      xcodeproj: @@project_path
    )
  end
end
