package com.techskillmatrix.model;

/**
 * Immutable view of a student's stored assessment scores.
 */
public final class UserResults {
    private final boolean hasData;
    private final int aptitude;
    private final int logic;
    private final int tech;
    private final int english;
    private final String recommendation;

    private UserResults(Builder builder) {
        this.hasData = builder.hasData;
        this.aptitude = builder.aptitude;
        this.logic = builder.logic;
        this.tech = builder.tech;
        this.english = builder.english;
        this.recommendation = builder.recommendation;
    }

    public boolean hasData() {
        return hasData;
    }

    public int getAptitude() {
        return aptitude;
    }

    public int getLogic() {
        return logic;
    }

    public int getTech() {
        return tech;
    }

    public int getEnglish() {
        return english;
    }

    public String getRecommendation() {
        return recommendation;
    }

    public static Builder builder() {
        return new Builder();
    }

    public static final class Builder {
        private boolean hasData;
        private int aptitude;
        private int logic;
        private int tech;
        private int english;
        private String recommendation;

        public Builder hasData(boolean value) {
            this.hasData = value;
            return this;
        }

        public Builder aptitude(int value) {
            this.aptitude = value;
            return this;
        }

        public Builder logic(int value) {
            this.logic = value;
            return this;
        }

        public Builder tech(int value) {
            this.tech = value;
            return this;
        }

        public Builder english(int value) {
            this.english = value;
            return this;
        }

        public Builder recommendation(String value) {
            this.recommendation = value;
            return this;
        }

        public UserResults build() {
            return new UserResults(this);
        }
    }
}


