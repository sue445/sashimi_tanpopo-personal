require_relative "../misc/terraform_helper"

@latest_terraform_version = TerraformHelper.latest_terraform_version

update_file ".github/workflows/terraform_upgrade_version.yml" do |content|
  content.gsub!(%r(terraform_version: +".+"), %Q(terraform_version: "#{@latest_terraform_version}"))
end
