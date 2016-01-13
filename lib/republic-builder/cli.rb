require "republic-builder"

module Harp2Hugo
  class CLI < Thor
    desc "convert [input_file] [output_dir]", "convert [input_file](default: _data.json) file into [output_dir](default: output) directory"
    def bintray(input_file="_data.json", output_dir="output")
      puts "Converting: #{input_file}"
      Dir.chdir(File.dirname(input_file))
      Harp2Hugo::Converter.new(File.basename(input_file)).convert(output_dir)
    end

    desc "convert [input_file] [output_dir]", "convert [input_file](default: _data.json) file into [output_dir](default: output) directory"
    def convert(input_file="_data.json", output_dir="output")
      puts "Converting: #{input_file}"
      Dir.chdir(File.dirname(input_file))
      Harp2Hugo::Converter.new(File.basename(input_file)).convert(output_dir)
    end

  end
end