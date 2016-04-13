var assert = require('assert')
var Gherkin = require('gherkin');

describe('Runner', function() {
  it('records results', function () {
    var parser = new Gherkin.Parser();
    var compiler = new Gherkin.Compiler()

    var feature = [
    "Feature: Single Scenario",
    "  Scenario: One Passing Step",
    "    Given a passing step"
    ].join("\n")

    var gherkinDocument = parser.parse(feature);
    var pickles = compiler.compile(gherkinDocument, "a.feature");

    var stepDefinitions = [
      new StepDef(/pass/, function() {})
    ]

    var glue = new Glue(stepDefinitions)
    var runner = new Runner(glue)

    var report = runner.execute(pickles)

    assert.equal(report.testCases.length, 1)
    assert.equal(report.testCasesPassed.length, 1)
  });
});
