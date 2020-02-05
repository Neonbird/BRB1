package app.workscript;

import app.storage.StorageException;

import java.io.*;
import java.lang.reflect.Array;
import java.nio.charset.StandardCharsets;

public class ScriptPython {
    private Process mProcess;

    public String runScript(String[] nameOfFiles, String nameOfScript, String... args) {
        String response = "";
        //todo проверить, работает ли user.dir всегда
        //just ways
        String pathToScript = System.getProperty("user.dir") + "/src/main/python/";
        String pathToFiles = System.getProperty("user.dir") + "/upload-dir/";
        // way+file
        String scriptName = pathToScript + nameOfScript;

        if (checkFile(pathToScript, nameOfScript)) {
            for (String filename : nameOfFiles) {
                if (checkFile(pathToFiles, filename)) {
                    response += executeScript(pathToFiles + filename, scriptName, args);
                }
            }
        }
        return response;
    }


    private String executeScript(String fileName, String scriptName, String... args) {
        String response = "";
        Process process;
        // todo как то надо сконкатенировать, чтобы норм запускалось)
        String[] s = concatenate(concatenate(new String[]{scriptName}, new String[]{fileName}), args);
        System.out.println(fileName);
        System.out.println(scriptName);
        try {
            process = Runtime.getRuntime().exec(new String[]{"python3", "/home/toharhymes/Загрузки/gs-uploading-files-master/complete/src/main/python/script_python.py", "arg1", "arg2"});
            mProcess = process;
        } catch (Exception e) {
            System.out.println("Exception Raised" + e.toString());
        }
        InputStream stdout = mProcess.getInputStream();
        BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, StandardCharsets.UTF_8));
        String line;
        try {
            while ((line = reader.readLine()) != null) {
                response += line;
                response += "\n";
            }
        } catch (IOException e) {
            System.out.println("Exception in reading output" + e.toString());
        }
        return response;
    }


    private boolean checkFile(String path, String filename) {
        System.out.println(path + filename);
        try {
            System.out.println(filename);
            if (filename.contains("..")) {
                // This is a security check
                throw new ScriptException(
                        "Cannot use file with relative path outside current directory "
                                + filename);
            }
            File file = new File(path + filename);
            if (!file.exists()) {
                throw new ScriptFileNotFoundException(
                        "Cannot find file "
                                + filename);
            }
            return true;
        } catch (ScriptException e) {
            throw new StorageException("Failed to use file " + filename, e);
        }
    }


    private <T> T concatenate(T a, T b) {
        if (!a.getClass().isArray() || !b.getClass().isArray()) {
            throw new IllegalArgumentException();
        }

        Class<?> resCompType;
        Class<?> aCompType = a.getClass().getComponentType();
        Class<?> bCompType = b.getClass().getComponentType();

        if (aCompType.isAssignableFrom(bCompType)) {
            resCompType = aCompType;
        } else if (bCompType.isAssignableFrom(aCompType)) {
            resCompType = bCompType;
        } else {
            throw new IllegalArgumentException();
        }

        int aLen = Array.getLength(a);
        int bLen = Array.getLength(b);

        @SuppressWarnings("unchecked")
        T result = (T) Array.newInstance(resCompType, aLen + bLen);
        System.arraycopy(a, 0, result, 0, aLen);
        System.arraycopy(b, 0, result, aLen, bLen);

        return result;
    }
}