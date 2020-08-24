#!/usr/bin/env ruby
require_relative 'lib/report'
require 'commander'
require 'dotenv'

ROOT_DIR = File.dirname(__FILE__) unless defined? ROOT_DIR
Dotenv.load("#{ROOT_DIR}/.env.#{ENV['RACK_ENV']}")
Dotenv.load("#{ROOT_DIR}/.env")

LOG = Logger.new(STDOUT)
LOG.formatter = proc { |_, _, _, msg| "#{msg}\n" }
LOG.level = Logger::DEBUG

class Cli
  include Commander::Methods

  #attr_reader :tag, :should_rollback, :config

  def initialize
    #@tag = nil
    #@should_rollback = nil
    #@config = Config.new
  end

  def run
    program :version, '1.0'
    program :description, 'program to interact with zoom'
    default_command :report
    command :report do |c|
      c.syntax = "#{__FILE__} #{c.name} [options]"
      c.summary = 'runs zoom meeting reports'
      c.example 'create a attendance report csv for meetings in a time range occurring over a date range',
        "#{__FILE__} #{c.name} --meeting-start-time-range=7:50-8:10 --meeting-date-range=7/28/20-8/3/20"
      c.option '--meeting-start-time-range STRING', String, 'The time range the meeting would have started'
      c.option '--meeting-date-range', 'The date range to pull the report for'

      c.action do |_args, options|
        puts "ARGS ARE #{_args}"
        puts "OPTIONS ARE #{options}"
        #@tag = options.tag
        #raise 'tag is required' if tag.to_s.strip.empty?
        #raise 'tag must be in the form "r[0-9]+-[0-9]"' if tag.match(/^r[0-9]+-[0-9]$/).nil?

        #@should_rollback = options.rollback.nil? ? false : options.rollback

        puts "Exiting"
        #apply_db
      end
    end

    run!
  end
end

Cli.new.run if $PROGRAM_NAME == __FILE__
