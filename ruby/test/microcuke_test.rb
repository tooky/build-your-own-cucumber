require 'gherkin/parser'
require 'gherkin/pickles/compiler'
require 'minitest/autorun'
require 'awesome_print'

class StepDef < Struct.new(:pattern, :body)

end

class Glue < Struct.new(:step_defs)
  def create_test_case(pickle)
    test_steps = []
    pickle[:steps].each do |pickle_step|
      step_def = step_defs.detect { |defintion| defintion.pattern.match(pickle_step[:text]) }
      test_step = TestStep.new(step_def.body)
      test_steps.push(test_step)
    end
    return TestCase.new(test_steps)
  end
end

class TestStep < Struct.new(:body)
  def execute
    body.call()
  end
end

class TestCase < Struct.new(:test_steps)
  def execute
    begin
      test_steps.each do |step|
        step.execute
      end
      return PassingResult.new
    rescue
      return FailingResult.new
    end
  end
end

class PassingResult
  def passed?
    return true
  end
end

class FailingResult
  def passed?
    return false
  end
end

class Report
  attr_reader :test_cases, :test_cases_passed

  def initialize
    @test_cases = []
    @test_cases_passed = []
  end

  def add_test_case(test_case)
    @test_cases.push(test_case)
  end

  def add_passing_test_case(test_case)
    @test_cases_passed.push(test_case)
  end
end

class Runner < Struct.new(:glue)
  def execute(pickles)
    report = Report.new
    pickles.each do |pickle|
      test_case = glue.create_test_case(pickle)
      report.add_test_case(test_case)

      result = test_case.execute

      if result.passed?
        report.add_passing_test_case(test_case)
      end
    end
    return report
  end
end

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
        StepDef.new(/pass/, ->() { puts "***************************" })
      ]

      glue = Glue.new(step_definitions)
      runner = Runner.new(glue)

      report = runner.execute(pickles)

      assert_equal 1, report.test_cases.count
      assert_equal 1, report.test_cases_passed.count
    end


    it "records only passing results" do
      parser = Gherkin::Parser.new
      compiler = Gherkin::Pickles::Compiler.new

      feature = <<-END
      Feature: Single Scenario
        Scenario: One Passing Step
          Given a passing step
          And a failing step
      END

      gherkin_document = parser.parse(feature)
      pickles = compiler.compile(gherkin_document, "a.feature")

      step_definitions = [
        StepDef.new(/pass/, ->() { puts "***************************" }),
        StepDef.new(/fail/, ->() { fail "an exception" }),
      ]

      glue = Glue.new(step_definitions)
      runner = Runner.new(glue)

      report = runner.execute(pickles)

      assert_equal 1, report.test_cases.count
      assert_equal 0, report.test_cases_passed.count
    end
  end
end
