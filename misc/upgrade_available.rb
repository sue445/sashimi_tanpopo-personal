# @param before_version [String]
# @param after_version [String]
def upgrade_available?(before_version:, after_version:)
  before = Gem::Version.new(before_version)
  after = Gem::Version.new(after_version)

  after > before
end
