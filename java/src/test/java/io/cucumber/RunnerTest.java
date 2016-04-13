package io.cucumber;

import gherkin.AstBuilder;
import gherkin.Parser;
import gherkin.ast.GherkinDocument;
import gherkin.pickles.Compiler;
import gherkin.pickles.Pickle;
import org.junit.Test;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

import static org.junit.Assert.assertEquals;


public class RunnerTest {

    @Test
    public void itRecordsResults() {
        Parser<GherkinDocument> parser = new Parser<>(new AstBuilder());
        Compiler compiler = new Compiler();

        String feature = String.join("\n",
                "Feature:",
                "  Scenario:",
                "    Given a passing step"
                );
        GherkinDocument gherkinDocument = parser.parse(feature);

        List<Pickle> pickles = compiler.compile(gherkinDocument, "path/to/the.feature");

        List<StepDefinition> stepDefinitions;
        stepDefinitions = Arrays.asList(
                new StepDefinition(Pattern.compile("pass"), () -> {})
        );

        Glue glue = new Glue(stepDefinitions);
        Runner runner = new Runner(glue);

        Report report = runner.execute(pickles);

        assertEquals(1, report.testCases.size());
        assertEquals(1, report.testCasesPassed.size());
    }
}
