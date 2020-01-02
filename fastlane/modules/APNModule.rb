# frozen_string_literal: true

module APNModule
  def self.init(
    fastlane:,
    debug_identifier:,
    staging_identifier:,
    production_identifier:,
    release_identifier:,
    dev_portal_appstore_apple_id:,
    dev_portal_appstore_team_id:,
    dev_portal_appstore_team_name:,
    dev_portal_development_apple_id:,
    dev_portal_development_team_id:,
    dev_portal_development_team_name:,
    apn_output_path:
  )
    @@fastlane = fastlane
    @@debug_identifier = debug_identifier
    @@staging_identifier = staging_identifier
    @@production_identifier = production_identifier
    @@release_identifier = release_identifier
    @@dev_portal_appstore_apple_id = dev_portal_appstore_apple_id
    @@dev_portal_appstore_team_id = dev_portal_appstore_team_id
    @@dev_portal_appstore_team_name = dev_portal_appstore_team_name
    @@dev_portal_development_apple_id = dev_portal_development_apple_id
    @@dev_portal_development_team_id = dev_portal_development_team_id
    @@dev_portal_development_team_name = dev_portal_development_team_name
    @@apn_output_path = apn_output_path
  end

  def self.get_push_certificate(update_development:, update_beta:, update_appstore:)
    pem_development(force: update_development)
    pem_beta(force: update_beta)
    pem_appstore(force: update_appstore)
  end

  private

  def self.pem_development(force:)
    @@fastlane.pem(
      development: true,
      force: force,
      app_identifier: @@debug_identifier,
      team_id: development_account[:team_id],
      team_name: development_account[:team_name],
      username: development_account[:username],
      pem_name: "apn #{@@debug_identifier}",
      output_path: @@apn_output_path
    )
  end

  def self.pem_beta(force:)
    @@fastlane.pem(
      development: false,
      force: force,
      app_identifier: @@staging_identifier,
      team_id: development_account[:team_id],
      team_name: development_account[:team_name],
      username: development_account[:username],
      pem_name: "apn #{@@staging_identifier}",
      output_path: @@apn_output_path
    )
    @@fastlane.pem(
      development: false,
      force: force,
      app_identifier: @@production_identifier,
      team_id: development_account[:team_id],
      team_name: development_account[:team_name],
      username: development_account[:username],
      pem_name: "apn #{@@production_identifier}",
      output_path: @@apn_output_path
    )
  end

  def self.pem_appstore(force:)
    @@fastlane.pem(
      development: false,
      force: force,
      app_identifier: @@release_identifier,
      team_id: appstore_account[:team_id],
      team_name: appstore_account[:team_name],
      username: appstore_account[:username],
      pem_name: "apn #{@@release_identifier}",
      output_path: @@apn_output_path
    )
  end

  def self.appstore_account
    {
      username: @@dev_portal_appstore_apple_id,
      team_name: @@dev_portal_appstore_team_name,
      team_id: @@dev_portal_appstore_team_id
    }
  end

  def self.development_account
    {
      username: @@dev_portal_development_apple_id,
      team_name: @@dev_portal_development_team_name,
      team_id: @@dev_portal_development_team_id
    }
  end
end
