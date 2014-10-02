Pod::Spec.new do |s|

  s.name         = "JBSpacer"
  s.version      = "1.0.0"
  s.summary      = "Determines optimal spacing for resizable grids."
  s.homepage     = "https://github.com/mikeswanson/JBSpacer"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = 'Mike Swanson'
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/mikeswanson/JBSpacer.git", :tag => s.version.to_s }
  s.source_files = 'JBSpacer/JBSpacer.{h,m}', 'JBSpacer/JBSpacerOption.{h,m}'
  s.requires_arc = true

end
