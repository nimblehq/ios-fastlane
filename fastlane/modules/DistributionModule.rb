# frozen_string_literal: true

module DistributionModule
  def self.init(
    fastlane:,
    build_path:,
    firebase_distribution_groups:,
    dev_portal_team_id:,
    dev_portal_team_name:,
    appstore_connect_team_id:,
    appstore_connect_team_name:,
    firebase_token:,
    gsp_path:
  )
    @@fastlane = fastlane
    @@build_path = build_path
    @@firebase_distribution_groups = firebase_distribution_groups
    @@dev_portal_team_id = dev_portal_team_id
    @@dev_portal_team_name = dev_portal_team_name
    @@appstore_connect_team_id = appstore_connect_team_id
    @@appstore_connect_team_name = appstore_connect_team_name
    @@firebase_token = firebase_token
    @@gsp_path = gsp_path
  end

  def self.upload_to_appstore(product_name:)
    @@fastlane.deliver(
      ipa: "#{@@build_path}/#{product_name}.ipa"
    )
  end

  def self.upload_to_firebase(product_name:, firebase_app_id:, notes:)
    build_path = "#{@@build_path}/#{product_name}"
    @@fastlane.firebase_app_distribution(
      app: firebase_app_id,
      ipa_path: "#{build_path}.ipa",
      release_notes: notes,
      groups: @@firebase_distribution_groups,
      firebase_cli_path: `which firebase`,
      firebase_cli_token: @@firebase_token
    )
  end

  def self.upload_symbols_to_firebase(product_name:, gsp_name:)
    @@fastlane.upload_symbols_to_crashlytics(
      dsym_path: "#{@@build_path}/#{product_name}.app.dSYM.zip",
      gsp_path: "#{@@gsp_path}/#{gsp_name}"
    )
  end
end
