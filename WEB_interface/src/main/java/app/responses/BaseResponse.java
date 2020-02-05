package app.responses;

import lombok.Getter;
import lombok.Setter;

public class BaseResponse {
    @Getter
    @Setter
    private int status;
    @Getter
    private Object answer;

    public BaseResponse(int status, Object answer) {
        this.status = status;
        this.answer = answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }
}
