require 'tutum'
require 'json'
require 'rufus-scheduler'
require 'logger'

namespace :littlebuilder do
  WORKING_DIR = 'trunk-stacks'
  @logger = Logger.new(STDOUT)
  @logger.progname = 'Scheduler'

  desc 'Schedules task'
  task :schedule_save_stack, [:stack_name, :schedule_type, :schedule_value] do |_, args|
    Vcs.clone_stacks
    Dir.chdir(WORKING_DIR)

    scheduler = Rufus::Scheduler.new
    scheduler.public_send(args[:schedule_type], args[:schedule_value]) do
      @logger.info "starting schedule"
      begin
        Vcs.pull_latest_stacks

        Stack.export_stack(args[:stack_name])
        Vcs.commit_stack
      rescue Exception => ex
        @logger.error ex.backtrace
        abort ex.message.red
      end
      @logger.info "ending schedule\n"
    end
    scheduler.join

  end

  desc 'Saves Tutum Stacks into Git'
  task :save_stack, [:stack_name] do |_, args|
    begin
      Vcs.clone_stacks
      Dir.chdir(WORKING_DIR)

      Vcs.pull_latest_stacks
      Stack.export_stack(args[:stack_name])
      Vcs.commit_stack
    rescue Exception => ex
      @logger.error ex.backtrace
      abort ex.message.red
    end
  end
end

module Vcs
  @logger = Logger.new(STDOUT)
  @logger.progname = 'Git'

  def self.clone_stacks
    @logger.debug `git clone git@github.com:Trunkplatform/trunk-stacks.git`.chomp unless Dir.exists?(WORKING_DIR)
  end

  def self.pull_latest_stacks
    @logger.debug `git pull`.chomp
  end


  def self.commit_stack
    @logger.debug `git add .`
    unless `git status`.include?("nothing to commit, working directory clean")
      @logger.info `git commit -m "auto commit"`.chomp
      @logger.info `git push origin master`.chomp
    else
      @logger.info "no changes".chomp
    end
  end
end

module Stack
  @logger = Logger.new(STDOUT)
  @logger.progname = "Tutum"

  def self.export_stack(stack_name)
    session = Tutum.new(username: "#{ENV['TUTUM_USERNAME']}", api_key: "#{ENV['TUTUM_API_KEY']}")

    stacks = session.stacks.list({"name" => stack_name})
    if stacks["objects"].empty?
      raise "stack: #{stack_name} not found"
    end

    stack_uuid = stacks["objects"][0]["uuid"]
    @logger.debug "exporting stack: #{stack_uuid}".chomp
    stack = session.stacks.export(stack_uuid)

    save_stack_file(stack_name, stack)
  end

  private_class_method def self.save_stack_file(stack_name, stack)
                         File.open("#{stack_name}.json", 'w') { |stack_file|
                           stack_file.write JSON.pretty_generate(stack)
                           @logger.debug "written file #{stack_name}.json".chomp
                         }
                       end

end