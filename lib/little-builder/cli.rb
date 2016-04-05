require "little-builder"
require "rancher/api"

module LittleBuilder
  class CLI < Thor
    desc "convert [input_file] [output_dir]", "convert [input_file](default: _data.json) file into [output_dir](default: output) directory"
    def bintray(input_file="_data.json", output_dir="output")
      puts "Converting: #{input_file}"
      Dir.chdir(File.dirname(input_file))
      Harp2Hugo::Converter.new(File.basename(input_file)).convert(output_dir)
    end

    desc "deploys [input_file] [output_dir]", "convert [input_file](default: _data.json) file into [output_dir](default: output) directory"
    def rancher_deploy(input_file="_data.json", output_dir="output")
      puts "Deploying: #{input_file}"

      config.url = ''
      config.access_key = ''
      config.secret_key = ''
      ::Converter.new(File.basename(input_file)).convert(output_dir)
    end


  end
end