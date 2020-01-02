# frozen_string_literal: true

module TestModule
  def self.init(fastlane:)
    @@fastlane = fastlane
  end

  def self.build(scheme:)
    @@fastlane.scan(scheme: scheme, build_for_testing: true)
  end

  def self.test(scheme:)
    @@fastlane.scan(scheme: scheme, test_without_building: true)
  end
end
