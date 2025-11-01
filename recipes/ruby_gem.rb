update_file ".github/workflows/rbs-collection-updater.yml" do |content|
  file = File.read(File.join(__dir__, "files", "ruby_gem", "rbs-collection-updater.yml"))
  content.replace(file)
end

update_file ".github/dependabot.yml" do |content|
  file = File.read(File.join(__dir__, "files", "ruby_gem", "dependabot.yml"))
  content.replace(file)
end
