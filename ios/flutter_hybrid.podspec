#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_hybrid'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter hybrid plugin.
                       DESC
  s.homepage         = 'http://git.missfresh.cn/mryt_flutter_base/flutter_hybrid.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mryt App' => 'mryt-appzu@missfresh.cn' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end

