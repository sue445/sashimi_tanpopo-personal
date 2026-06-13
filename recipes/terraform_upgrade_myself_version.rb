update_file ".github/workflows/terraform_upgrade_version.yml" do |content|
  content.gsub!(%r(terraform_version: +".+"), %Q(terraform_version: "#{params[:terraform_version]}"))
end
