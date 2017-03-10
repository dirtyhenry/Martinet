desc 'Install pods'
task :pod_install do |t|
  sh "bundle exec pod install --project-directory=Example/"
end

desc 'Validate the pod'
task :pod_lint do |t|
  sh "bundle exec pod lib lint"
end

desc 'Open the project'
task :open do |t|
  sh "open Example/Martinet.xcworkspace"
end
