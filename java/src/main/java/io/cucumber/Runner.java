package io.cucumber;

import gherkin.pickles.Pickle;

import java.util.List;

public class Runner {
    public Runner(Glue glue) {

    }

    public Report execute(List<Pickle> pickles) {
        return new Report();
    }
}
