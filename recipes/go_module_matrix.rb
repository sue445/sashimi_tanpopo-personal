GO_VERSIONS = %w(
  1.25
  1.26
)

require_relative "../misc/go_module_matrix_helper"

# Add go version to CI matrix
update_file ".github/workflows/*.yml" do |content|
  add_version_to_matrix(content:, go_versions: GO_VERSIONS)
end

update_file ".golangci-lint-version" do |content|
  content.replace("#{params[:golangci_lint_version]}\n")
end

update_file ".tool-versions" do |content|
  content.gsub!(/^golangci-lint ([\d.]+)$/, "golangci-lint #{params[:golangci_lint_version]}")
end
