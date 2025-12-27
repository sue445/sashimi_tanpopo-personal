RUBY_VERSIONS = %w(
  3.4
  4.0
)

require_relative "../misc/ruby_gem_matrix_helper"

# Add ruby version to CI matrix
update_file ".github/workflows/*.yml" do |content|
  add_version_to_matrix(content:, ruby_versions: RUBY_VERSIONS)
end

update_file ".circleci/config.yml" do |content|
  add_version_to_matrix(content:, ruby_versions: RUBY_VERSIONS)
end

update_file ".gitlab-ci.yml" do |content|
  add_version_to_matrix(content:, ruby_versions: RUBY_VERSIONS)
end
