def indent(content, amount)
  result = ""
  content.each_line do |line|
    result << " " * amount + line
  end
  result
end

HEADER = indent(<<~YAML, 2)
###########################################################
# NOTE: following sections are auto generated. DO NOT EDIT!
###########################################################
YAML

FOOTER = indent(<<~YAML, 2)
###########################################################
YAML

update_file ".github/dependabot.yml" do |content|
  if content =~ /^  - package-ecosystem: github-actions$/
    yaml = indent(<<~YAML, 2)
      - package-ecosystem: github-actions
        directory: /
        schedule:
          interval: monthly
          time: "05:00"
          timezone: Asia/Tokyo
        assignees:
          - sue445
        cooldown:
          default-days: 7
    YAML

    if File.exist?("Gemfile")
      # Append to cooldown.exclude
      yaml << indent(<<~YAML, 6)
        exclude:
          - ruby/setup-ruby
      YAML
    end

    section_yaml = "#{HEADER}#{yaml}#{FOOTER}"
    if content.include?("#{HEADER}  - package-ecosystem: github-actions")
      content.gsub!(/(#{HEADER}  -\s+package-ecosystem: github-actions[\s\S]*?)#{FOOTER}/m, section_yaml)
    else
      content.gsub!(%r{(  -\s+package-ecosystem: github-actions\n    directory: /\n[\s\S]*?)(?=  -\s+package-ecosystem:|\Z)}m, section_yaml)
    end
  end

  if content =~ /^  - package-ecosystem: bundler$/
    yaml = indent(<<~YAML, 2)
      - package-ecosystem: bundler
        directory: /
        schedule:
          interval: daily
          time: "05:00"
          timezone: Asia/Tokyo
        assignees:
          - sue445
        versioning-strategy: lockfile-only
        cooldown:
          default-days: 7
    YAML

    section_yaml = "#{HEADER}#{yaml}#{FOOTER}"
    if content.include?("#{HEADER}  - package-ecosystem: bundler")
      content.gsub!(/(#{HEADER}  -\s+package-ecosystem: bundler[\s\S]*?)#{FOOTER}/m, section_yaml)
    else
      content.gsub!(%r{(  -\s+package-ecosystem: bundler\n    directory: /\n[\s\S]*?)(?=  -\s+package-ecosystem:|\Z)}m, section_yaml)
    end
  end

  if content =~ /^  - package-ecosystem: gomod$/
    yaml = indent(<<~YAML, 2)
      - package-ecosystem: gomod
        directory: /
        schedule:
          interval: daily
          time: "05:00"
          timezone: Asia/Tokyo
        assignees:
          - sue445
        cooldown:
          default-days: 7
    YAML

    section_yaml = "#{HEADER}#{yaml}#{FOOTER}"
    if content.include?("#{HEADER}  - package-ecosystem: gomod")
      content.gsub!(/(#{HEADER}  -\s+package-ecosystem: gomod[\s\S]*?)#{FOOTER}/m, section_yaml)
    else
      content.gsub!(%r{(  -\s+package-ecosystem: gomod\n    directory: /\n[\s\S]*?)(?=  -\s+package-ecosystem:|\Z)}m, section_yaml)
    end
  end

  content.gsub!("#{FOOTER}#{HEADER}", "#{FOOTER}\n#{HEADER}")
end
