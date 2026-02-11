# @param content [String]
# @param go_versions [Array<String>]
def add_version_to_matrix(content:, go_versions:)
  go_versions.each_cons(2) do |prev_version, next_version|
    # using actions/setup-go
    unless content.include?(%Q{- "#{next_version}"})
      # e.g.
      # Before
      # - "1.25"
      # After
      # - "1.25"
      # - "1.26"
      content.gsub!(/^( +)-\s+"#{prev_version}"$/) do
        %Q{#{$1}- "#{prev_version}"\n#{$1}- "#{next_version}"}
      end
    end
  end
end
