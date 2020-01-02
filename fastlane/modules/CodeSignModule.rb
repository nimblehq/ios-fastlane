# frozen_string_literal: true

module CodeSignModule
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
    keychain_name:,
    keychain_password:,
    support_enterprise_distribution:,
    branch_name:
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
    @@keychain_name = keychain_name
    @@keychain_password = keychain_password
    @@support_enterprise_distribution = support_enterprise_distribution
    @@branch_name = branch_name
    @@is_ci = !branch_name.nil?
  end

  def self.sync_code_sign(update_development:, update_beta:, update_appstore:)
    # on local machine BRANCH_NAME will be nil
    if @@is_ci
      # override keychain name from by adding '-${branch_name}'
      @@keychain_name = @@keychain_name + '-' + @@branch_name.sub('/', '-')
    end

    create_keychain_if_needed(keychain_name: @@keychain_name, keychain_password: @@keychain_password)

    if @@is_ci
      @@branch_name == 'master' ? match_appstore(update: false) : match_beta(update: false)
    else
      match_development(update: update_development)
      match_beta(update: update_beta)
      match_appstore(update: update_appstore)
    end
  end

  private

  def self.create_keychain_if_needed(keychain_name:, keychain_password:)
    keychain_password = @@is_ci ? keychain_password : @@fastlane.prompt(
      text: "\n\n 🔐 Creating '#{keychain_name}' keychain ... \n\n 🔑 Please fill in '#{keychain_name}' keychain's password: ",
      secure_text: true
    )
    @@fastlane.create_keychain(
      name: keychain_name,
      default_keychain: false,
      unlock: true,
      timeout: @@is_ci ? false : 300,
      password: keychain_password
    )
  end

  def self.match_development(update:)
    @@fastlane.match(
      type: 'development',
      app_identifier: @@debug_identifier,
      keychain_name: @@keychain_name,
      force_for_new_devices: update,
      force: update,
      readonly: !update,
      username: @@dev_portal_development_apple_id,
      team_name: @@dev_portal_development_team_name,
      team_id: @@dev_portal_development_team_id
    )
  end

  def self.match_beta(update:)
    @@fastlane.match(
      type: @@support_enterprise_distribution ? 'enterprise' : 'adhoc',
      app_identifier: [@@staging_identifier, @@production_identifier],
      keychain_name: @@keychain_name,
      force_for_new_devices: @@support_enterprise_distribution ? false : update,
      force: update,
      readonly: !update,
      username: @@dev_portal_development_apple_id,
      team_name: @@dev_portal_development_team_name,
      team_id: @@dev_portal_development_team_id
    )
  end

  def self.match_appstore(update:)
    @@fastlane.match(
      type: 'appstore',
      app_identifier: @@release_identifier,
      force_for_new_devices: false,
      readonly: !update,
      force: update,
      username: @@dev_portal_appstore_apple_id,
      team_name: @@dev_portal_appstore_team_name,
      team_id: @@dev_portal_appstore_team_id
    )
  end
end
