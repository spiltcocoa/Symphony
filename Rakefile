

desc 'Build Symphony'
task :build do
    sh "xcodebuild -project 'Symphony.xcodeproj' -scheme 'Symphony' -destination 'platform=iOS Simulator,name=iPhone 6,OS=latest' CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= PROVISIONING_PROFILE= clean build"
end

desc 'Test Symphony'
task :test do
    sh "xcodebuild -project 'Symphony.xcodeproj' -scheme 'Symphony' -destination 'platform=iOS Simulator,name=iPhone 6,OS=latest' CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= PROVISIONING_PROFILE= clean test"
end

desc 'Test Symphony the way that CircleCI does.'
task :circle => :test



