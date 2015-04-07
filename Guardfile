# encoding: utf-8

guard :rspec, cmd: "bundle exec rspec" do

  watch(%r{^lib/(.+)\.rb$}) do |m|
    "spec/tests/#{ m[1] }_spec.rb"
  end

  watch(%r{spec/tests/.+_spec\.rb})

  watch("lib/chronicles.rb")   { "spec" }
  watch("spec/spec_helper.rb") { "spec" }
  watch(%r{spec/support/})     { "spec" }

end # guard :rspec
