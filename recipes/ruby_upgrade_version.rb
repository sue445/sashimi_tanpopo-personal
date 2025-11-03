def ruby_version_with_patch_level(ruby_version)
  v = ruby_version.split(".")
  return nil unless v.size == 3

  # Fetch RUBY_PATCHLEVEL from https://github.com/ruby/ruby/blob/master/version.h
  git_tag = "v" + ruby_version.gsub(".", "_")
  version_h = URI.open("https://raw.githubusercontent.com/ruby/ruby/#{git_tag}/version.h").read
  ruby_patchlevel = /^#define\s+RUBY_PATCHLEVEL\s+(\d+)/.match(version_h).to_a[1]

  "#{ruby_version}p#{ruby_patchlevel}"
end

v = params[:ruby_version].split(".")

@is_full_version = v.count == 3
@ruby_minor_version = "#{v[0]}.#{v[1]}"
@gcp_runtime_version = "ruby#{v[0]}#{v[1]}"
@ruby_version_with_patch_level = ruby_version_with_patch_level(params[:ruby_version])

update_file ".circleci/config.yml" do |content|
  content.gsub!(%r{- image: circleci/ruby:[\d.]+}, "- image: circleci/ruby:#{params[:ruby_version]}")
  content.gsub!(%r{- image: cimg/ruby:[\d.]+},     "- image: cimg/ruby:#{params[:ruby_version]}")
end

if @is_full_version
  update_file ".ruby-version" do |content|
    content.gsub!(/[\d.]+/, params[:ruby_version])
  end
end

update_file "Gemfile" do |content|
  if @is_full_version
    content.gsub!(/^ruby "([\d.]+)"$/, %Q{ruby "#{params[:ruby_version]}"})
    content.gsub!(/^ruby '([\d.]+)'$/, %Q{ruby '#{params[:ruby_version]}'})
  else
    content.gsub!(/^ruby "~> ([\d.]+)"$/, %Q{ruby "~> #{@ruby_minor_version}.0"})
    content.gsub!(/^ruby '~> ([\d.]+)'$/, %Q{ruby '~> #{@ruby_minor_version}.0'})
  end
end

if @ruby_version_with_patch_level
  update_file "Gemfile.lock" do |content|
    content.gsub!(/^RUBY VERSION\n   ruby ([\d.p]+)\n/m) do
      <<~GEMFILE_LOCK
        RUBY VERSION
           ruby #{@ruby_version_with_patch_level}
        GEMFILE_LOCK
    end
  end
end

update_file ".rubocop.yml" do |content|
  content.gsub!(/TargetRubyVersion: ([\d.]+)/, "TargetRubyVersion: #{@ruby_minor_version}")
end

update_file ".github/workflows/*.yml" do |content|
  content.gsub!(/ruby-version: "(.+)"/, %Q{ruby-version: "#{params[:ruby_version]}"})

  content.gsub!(/ruby\d{2}(?!\d)/, @gcp_runtime_version)
end

update_file ".tool-versions" do |content|
  content.gsub!(/^ruby ([\d.]+)$/, "ruby #{params[:ruby_version]}")
end

update_file "Dockerfile" do |content|
  content.gsub!(/^FROM ruby:\\([\d.]+\\)$/, %Q{FROM ruby:#{params[:ruby_version]}})
  content.gsub!(/^FROM ruby:\\([\d.]+\\)-$(.+)$/) { %Q{FROM ruby:#{params[:ruby_version]}-#{$1}} }
  content.gsub!(/^ARG RUBY_VERSION=\\([\d.]+\\)$/, %Q{ARG RUBY_VERSION=#{params[:ruby_version]}})
end
