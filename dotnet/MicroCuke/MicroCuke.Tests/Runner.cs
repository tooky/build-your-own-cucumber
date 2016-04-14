using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MicroCuke.Tests
{
  class Runner
  {
    private Glue glue;

    public Runner(Glue glue)
    {
      // TODO: Complete member initialization
      this.glue = glue;
    }

    internal Report Execute(List<Gherkin.Ast.ScenarioDefinition> list)
    {
      return new Report();
    }
  }
}
