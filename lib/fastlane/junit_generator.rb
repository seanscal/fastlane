require 'nokogiri'

module Fastlane
  class JUnitGenerator
    def self.generate(results, path = nil)
      # Junit file documentation: http://llg.cubic.org/docs/junit/
      # And http://nelsonwells.net/2012/09/how-jenkins-ci-parses-and-displays-junit-output/

      path ||= "./report.xml"


      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.testsuites(name: "fastlane") {
          xml.testsuite(name: "deploy") {
            results.each_with_index do |current, index|
              xml.testcase(name: [index, current[:name]].join(": "), time: current[:time]) {
                xml.failure(message: current[:error]) if current[:error]
                xml.system_out current[:output] if current[:output]
              }
            end
          }
        }
      end
      result = builder.to_xml.gsub("system_", "system-")

      File.write(path, result)
    end
  end
end