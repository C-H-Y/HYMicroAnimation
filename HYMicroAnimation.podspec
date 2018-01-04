Pod::Spec.new do |s|


s.name         = "HYMicroAnimation"
s.version      = "1.0.2"
s.summary      = "一个微动画集合项目"

s.homepage     = "https://github.com/C-H-Y/HYMicroAnimation"
s.license      = "GPL"

s.author             = { "CHY" => "everchenghy@126.com" }
s.source       = { :git => "https://github.com/C-H-Y/HYMicroAnimation.git", :tag => s.version }
s.platform     = :ios,'8.0'
s.requires_arc = true
s.source_files  = 'HYMicroAnimation/**/*.{h,m}'
# s.resource  = "icon.png"
# s.resources = "Resources/*.png"

s.framework  = "UIkit","QuartzCore"
# s.frameworks = "SomeFramework", "AnotherFramework"

# s.library   = "iconv"
# s.libraries = "iconv", "xml2"

end
