if params[:bundler_version] && params[:bundler_version] != ""
  update_file "Gemfile.lock" do |content|
    content.gsub!(/^BUNDLED WITH\n +([\d.]+)\n/m) do
      <<~GEMFILE_LOCK
      BUNDLED WITH
        #{params[:bundler_version]}
      GEMFILE_LOCK
    end
  end
end
