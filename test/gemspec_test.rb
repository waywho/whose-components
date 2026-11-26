# frozen_string_literal: true

require "test_helper"

class GemspecTest < ActiveSupport::TestCase
  ROOT = File.expand_path("..", __dir__)

  test "packs only files that git tracks, also when CI installs gems into vendor/bundle" do
    bundle_dir = File.join(ROOT, "vendor/bundle")
    made_bundle_dir = !Dir.exist?(bundle_dir)
    stray = File.join(bundle_dir, "ruby/stray.rb")
    FileUtils.mkdir_p(File.dirname(stray))
    File.write(stray, "")

    files = Dir.chdir(ROOT) { Gem::Specification.load("whose-components.gemspec").files }
    tracked = Dir.chdir(ROOT) { `git ls-files -z`.split("\x0") }

    assert_includes files, "app/models/concerns/whose/authenticatable.rb"
    assert_empty files - tracked
  ensure
    made_bundle_dir ? FileUtils.rm_rf(bundle_dir) : FileUtils.rm_f(stray)
  end
end
