class AddNewPostDiscordWebhookUrlToTenantSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :tenant_settings, :new_post_discord_webhook_url, :string, null: true
  end
end
