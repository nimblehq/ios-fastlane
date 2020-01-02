# frozen_string_literal: true

module BuildModule
  def self.init(
    fastlane:,
    support_enterprise_distribution:,
    dev_portal_appstore_apple_id:,
    dev_portal_appstore_team_id:,
    dev_portal_appstore_team_name:,
    dev_portal_development_apple_id:,
    dev_portal_development_team_id:,
    dev_portal_development_team_name:
  )
    @@fastlane = fastlane
    @@support_enterprise_distribution = support_enterprise_distribution
    @@dev_portal_appstore_apple_id = dev_portal_appstore_apple_id
    @@dev_portal_appstore_team_id = dev_portal_appstore_team_id
    @@dev_portal_appstore_team_name = dev_portal_appstore_team_name
    @@dev_portal_development_apple_id = dev_portal_development_apple_id
    @@dev_portal_development_team_id = dev_portal_development_team_id
    @@dev_portal_development_team_name = dev_portal_development_team_name
  end

  def self.build(scheme:, is_appstore_method:, product_name:)
    other_method = @@support_enterprise_distribution ? 'enterprise' : 'ad-hoc'
    @@fastlane.gym(
      export_method: is_appstore_method ? 'app-store' : other_method,
      export_team_id: is_appstore_method ? @@dev_portal_appstore_team_id : @@dev_portal_development_team_id,
      scheme: scheme,
      output_name: "#{product_name}.ipa"
    )
  end
end
