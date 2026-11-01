GO_VERSIONS = %w(
  1.25
  1.26
  1.27
)

require_relative "../misc/go_module_matrix_helper"
require_relative "../misc/upgrade_available"

# Add go version to CI matrix
update_file ".github/workflows/*.yml" do |content|
  add_version_to_matrix(content:, go_versions: GO_VERSIONS)
end

update_file ".golangci-lint-version" do |content|
  before_version = content.strip
  after_version = params[:golangci_lint_version]

  if upgrade_available?(before_version:, after_version:)
    content.replace("#{after_version}\n")
  end
end

update_file ".tool-versions" do |content|
  if content =~ /^golangci-lint ([\d.]+)$/
    before_version = $1.strip
    after_version = params[:golangci_lint_version]

    if upgrade_available?(before_version:, after_version:)
      content.gsub!(/^golangci-lint ([\d.]+)$/, "golangci-lint #{after_version}")
    end
  end
end
