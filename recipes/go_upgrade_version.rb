@go_minor_version = params[:go_version].to_f

v = params[:go_version].split(".")
@gcp_runtime_version = "go#{v[0]}#{v[1]}"

update_file ".github/workflows/*.yml" do |content|
  content.gsub!(/go-version:\s+[\d.]+\s*$/, "go-version: #{params[:go_version]}")
  content.gsub!(/GO_VERSION:\s+[\d.]+$/, "GO_VERSION: #{params[:go_version]}")
  content.gsub!(/GOLANGCI_LINT_VERSION: v[0-9.]+/, "GOLANGCI_LINT_VERSION: #{params[:golangci_lint_version]}")

  content.gsub!(/go\d{3}(?!\d)/, @gcp_runtime_version )
end

update_file "app.yaml" do |content|
  content.gsub!(/go\d{3}(?!\d)/, @gcp_runtime_version )
end

update_file "go.mod" do |content|
  content.gsub!(/^go [\d.]+$/, "go #{params[:go_version]}")
end

update_file ".circleci/config.yml" do |content|
  content.gsub!(%r{- image: circleci/golang:[\d.]+}, "- image: circleci/golang:#{@go_minor_version}")
  content.gsub!(%r{- image: cimg/go:[\d.]+}, "- image: cimg/go:#{@go_minor_version}")
end

update_file "Dockerfile" do |content|
  content.gsub!(/^FROM golang:([\d.]+)/, %Q{FROM golang:#{@go_minor_version}})
end

update_file ".gitlab-ci.yml" do |content|
  content.gsub!(/GO_VERSION:\s+"[\d.]+"$/, %Q{GO_VERSION: "#{@go_minor_version}"})
  content.gsub!(/GOLANGCI_LINT_VERSION: "v[0-9.]+"/, %Q{GOLANGCI_LINT_VERSION: "#{params[:golangci_lint_version]}"})
end

update_file ".golangci-lint-version" do |content|
  content.replace("#{params[:golangci_lint_version]}\n")
end

update_file ".tool-versions" do |content|
  content.gsub!(/^golangci-lint ([\d.]+)$/, "golangci-lint #{params[:golangci_lint_version]}")
end
