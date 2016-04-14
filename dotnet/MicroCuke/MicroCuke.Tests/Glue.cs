using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MicroCuke.Tests
{
  class Glue
  {
    private List<StepDefinition> stepDefinitions;

    public Glue(List<StepDefinition> stepDefinitions)
    {
      // TODO: Complete member initialization
      this.stepDefinitions = stepDefinitions;
    }
  }
}
