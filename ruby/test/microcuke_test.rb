require 'gherkin/parser'
require 'gherkin/pickles/compiler'
require 'minitest/autorun'
require 'awesome_print'

class MicrocukeSpec < Minitest::Test
  describe "Runner" do
    it "records results" do
      parser = Gherkin::Parser.new
      compiler = Gherkin::Pickles::Compiler.new

      feature = <<-END
      Feature: Single Scenario
        Scenario: One Passing Step
          Given a passing step
      END

      gherkin_document = parser.parse(feature)
      pickles = compiler.compile(gherkin_document, "a.feature")

      step_definitions = [
        StepDef.new(/pass/, ->() {})
      ]

      glue = Glue.new(step_definitions)
      runner = Runner.new(glue)

      report = runner.execute(pickles)

      assert_equal 1, report.test_cases.count
      assert_equal 1, report.test_cases_passed.count
    end
  end
end
