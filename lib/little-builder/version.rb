module LittleBuilder
  VERSION = ENV['SNAP_PIPELINE_COUNTER'] || '0'

  def self.version
    VERSION
  end
end
