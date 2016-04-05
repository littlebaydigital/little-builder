require 'colored'
require 'little-builder/bintray'

namespace :littlebuilder do
  desc 'Builds mobile app using PhoneGapBuild'
  task :download_bintray[:organisation, :repository, :file]  do
    # version = "0.1.#{ENV['SNAP_PIPELINE_COUNTER']}"
    environment = ENV['ENVIRONMENT']

    bintray = LittleBuilder::BintrayHelper.new(args[:organisation], args[:repository])

    begin
      bintray.download(args[:file])
    rescue Exception => ex
      puts ex.message.red
      puts ex.backtrace
    end
  end
end