package app.responses;

import lombok.Getter;
import lombok.Setter;

public class TextResponse {
    @Getter
    @Setter
    private int status;
    @Getter
    private Object answer;

    public TextResponse(int status, Object answer) {
        this.status = status;
        this.answer = answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }
}