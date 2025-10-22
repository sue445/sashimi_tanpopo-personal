require "json"

module TerraformHelper
  # @return [String]
  def self.latest_terraform_version
    tags = github_stable_tag_names("hashicorp/terraform")
    versions = tags.map { |tag| tag.gsub(/^v/, "") }
    versions.max_by { |v| Gem::Version.create(v) }
  end

  # @param repo_name [String]
  # @return [Array<String>]
  def self.github_stable_tag_names(repo_name)
    tags = JSON.parse(`gh api repos/#{repo_name}/tags`)
    tag_names = tags.map { |tag| tag["name"] }
    tag_names.select { |tag| tag.match?(/v[.0-9]+$/) }
  end
end
