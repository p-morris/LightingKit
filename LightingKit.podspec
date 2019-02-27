Pod::Spec.new do |spec|
  spec.name = 'LightingKit'
  spec.version = '1.4.0'
  spec.summary = 'A simple iOS library that helps you to discover and control HomeKit lightbulbs.'
  spec.homepage = 'https://github.com/p-morris/LightingKit'
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { 'Pete Morris' => 'pete@iosfaststart.com' }
  spec.social_media_url = 'https://stackoverflow.com/users/10246061/pete-morris'
  spec.swift_version = '4.2'
  spec.platform = :ios, '12'
  spec.requires_arc = true
  spec.source = { git: 'https://github.com/p-morris/LightingKit.git', tag: "#{spec.version}", submodules: true }
  spec.source_files = 'LightingKit/**/*.swift'
  spec.framework    = 'HomeKit'
  spec.test_spec do |test_spec|
    test_spec.source_files = 'LightingKitTests/**/*.swift'
  end
end
