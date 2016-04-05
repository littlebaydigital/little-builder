require 'json'
require 'rest_client'
require 'colored'

module LittleBuilder
  class Bintray

    def initialize(organisation, repository)
      raise 'Failure: Make sure you specified BINTRAY_USERNAME and BINTRAY_API_KEY'.red if ENV["BINTRAY_USER"].nil? || ENV["BINTRAY_APIKEY"].nil?
      @repository = repository
      @organisation = organisation

      @download_url_prefix = "https://#{ENV["BINTRAY_USERNAME"]}:#{ENV["BINTRAY_API_KEY"]}"+
          "@dl.bintray.com/#{@organisation}/#{@repository}"
      @upload_url_prefix = "https://#{ENV["BINTRAY_USERNAME"]}:#{ENV["BINTRAY_API_KEY"]}@api.bintray.com/content/trunkplatform/#{@repository}"

      @delete_url_prefix = "https://api.bintray.com/packages/#{@repository}/versions/latest"
    end

    def download(file_path)
      puts "Downloading from Bintray, File: #{file_path}".yellow
      response = RestClient::Request.execute(method: :get, url: @download_url_prefix + "/" + file_path)
      file = File.new(file_path, 'wb') # has to be binary mode!
      file.write(response.body)
      file.close
    end

    def delete(bintray_file_path, local_file_path, package)
      puts "Deleting from Bintray, File: #{local_file_path}".yellow

      response = RestClient::Request.execute(method: :delete,
                                             url: "#{@upload_url_prefix}/#{bintray_file_path};bt_package=#{package};bt_version=#{version}",
                                             user: ENV["BINTRAY_USERNAME"],
                                             password: ENV["BINTRAY_API_KEY"])

      puts response
      raise "Failed to delete: #{response.code} #{response.body}".red unless upload_successful?(response)
      response.body
    end

    def upload(version, bintray_file_path, local_file_path, package)
      puts "Uploading File #{local_file_path} to Bintray; version: #{version.to_s}".yellow

      response = RestClient::Request.execute(method: :put,
                                             url: "#{@upload_url_prefix}/#{bintray_file_path};bt_package=#{package};bt_version=#{version}",
                                             payload: File.open(local_file_path, 'rb'),
                                             headers: {'X-BintrayHelper-Publish' => '1'},
                                             user: ENV["BINTRAY_USERNAME"],
                                             password: ENV["BINTRAY_API_KEY"])

      puts response
      raise "Failed to upload: #{response.code} #{response.body}".red unless upload_successful?(response)
      response.body
    end

    def upload_successful?(response)
      response.code == 201
    end

  end

end
