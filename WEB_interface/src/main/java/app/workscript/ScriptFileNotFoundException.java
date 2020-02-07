package app.workscript;

public class ScriptFileNotFoundException extends ScriptException {

    public ScriptFileNotFoundException(String message) {
        super(message);
    }

    public ScriptFileNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}