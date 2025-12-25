RUBY_VERSIONS = %w(
  3.4
  4.0
)

def add_version_to_matrix(content)
  RUBY_VERSIONS.each_cons(2) do |prev_version, next_version|
    # using ruby/setup-ruby
    unless content.include?(%Q{- "#{next_version}"})
      # e.g.
      # Before
      # - "3.4"
      # After
      # - "3.4"
      # - "4.0"
      content.gsub!(/^( +)-\s+"#{prev_version}"$/) do
        %Q{#{$1}- "#{prev_version}"\n#{$1}- "#{next_version}"}
      end
    end

    # using DockerHub ruby
    unless content.include?(%Q{- ruby:#{next_version}})
      # e.g.
      # Before
      # - ruby:3.4
      # After
      # - ruby:3.4
      # - ruby:4.0
      content.gsub!(/^( +)-\s+ruby:#{prev_version}$/) do
        %Q{#{$1}- ruby:#{prev_version}\n#{$1}- ruby:#{next_version}}
      end
    end
  end
end

# Add ruby version to CI matrix
update_file ".github/workflows/*.yml" do |content|
  add_version_to_matrix(content)
end

update_file ".circleci/config.yml" do |content|
  add_version_to_matrix(content)
end

update_file ".gitlab-ci.yml" do |content|
  add_version_to_matrix(content)
end
