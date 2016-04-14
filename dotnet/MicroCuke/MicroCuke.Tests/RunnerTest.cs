using System;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Gherkin;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Gherkin.Ast;
using System.IO;

namespace MicroCuke.Tests
{
  [TestClass]
  public class RunnerTest
  {
    [TestMethod]
    public void ItRecordsResults()
    {
      var parser = new Parser();
      String feature = @"
                Feature:
                  Scenario:
                    Given a passing step";

      var gherkinDocument = parser.Parse(new StringReader(feature));

      // No Pickles for Gherkin.NET yet
      // so we'll just use the first scenario, and assume there are
      // no backgrounds or scenario outlines

      var scenario = gherkinDocument.Feature.Children.First();

      var stepDefinitions = new List<StepDefinition>()
      {
        new StepDefinition(new Regex("pass"), () => {})
      };

      var glue = new Glue(stepDefinitions);
      var runner = new Runner(glue);

      var report = runner.Execute(new List<ScenarioDefinition>() { scenario });

      Assert.AreEqual(1, report.TestCases.Count);
      Assert.AreEqual(1, report.TestCasesPassed.Count);
    }
  }
}
