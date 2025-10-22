update_file ".terraform-version" do |content|
  content.replace("#{params[:terraform_version]}\n")
end
