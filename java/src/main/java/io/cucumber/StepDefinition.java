package io.cucumber;

import java.util.regex.Pattern;

public class StepDefinition {
    public StepDefinition(Pattern regex, NoArgBody p1) {
    }

    interface NoArgBody {
        void call();
    }
}
