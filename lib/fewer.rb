module Fewer
  class << self
    attr_writer :logger

    def logger
      @logger ||= begin
        defined?(Rails) ? Rails.logger : begin
          require 'logger'
          log = Logger.new(STDOUT)
          log.level = Logger::INFO
          log
        end
      end
    end
  end
end

require 'fewer/app'
require 'fewer/engines'
require 'fewer/errors'
require 'fewer/middleware'
require 'fewer/rails_helpers'
require 'fewer/serializer'
