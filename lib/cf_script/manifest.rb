# encoding: utf-8

require 'yaml'

class CfScript::Manifest
  attr_reader :filename
  attr_reader :applications

  include CfScript::Utils

  FILENAME = 'manifest.yml'

  def initialize(filename = FILENAME)
    @filename = filename

    @applications = load_file
  end

  def each
    applications.each do |app|
      yield app
    end
  end

  private

  def load_file
    data = if File.exist?(filename)
      YAML.load(File.open(filename))
    else
      { 'applications' => [] }
    end

    data['applications'].map do |app|
      OpenStruct.new(symbolize_keys(app))
    end
  end
end
