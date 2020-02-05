package app.tables;

import java.io.*;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class VcfToTable {


    private static final String TABLE_STRUCTURE = new String(
            "<th>gene_set</th>\n" +
                    "<th>p-value</th>\n" +
                    "<th>q-value</th>\n" +
                    "<th>enrich_description</th>\n"
    );


    private static StringBuffer readUsingBufferedReader(String fileName) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(fileName));
        String line = null;
        StringBuffer stringBuffer = new StringBuffer();
        String ls = System.getProperty("line.separator");
        while ((line = reader.readLine()) != null) {
            stringBuffer.append(line);
            stringBuffer.append(ls);
        }

        stringBuffer.deleteCharAt(stringBuffer.length() - 1);
        return stringBuffer;
    }

    private static StringBuffer replaceBuf(StringBuffer inputString, String oldPattern, String newPattern) {
        Pattern p = Pattern.compile(oldPattern);
        Matcher m = p.matcher(inputString);
        StringBuffer sb = new StringBuffer();
        while (m.find()) {
            m.appendReplacement(sb, newPattern);
        }
        m.appendTail(sb);
        return sb;
    }


    private static ArrayList<String> header() {
        ArrayList<String> header = new ArrayList<>();
        header.add("gene_set");
        header.add("p-value");
        header.add("q-value");
        header.add("enrich_description");
        return header;
    }

    private static ArrayList<ArrayList<String>> vcf_to_array(String fileName) throws IOException {
        String file = readUsingBufferedReader(fileName).toString();
        ArrayList<ArrayList<String>> answerArray = new ArrayList<>();
        answerArray.add(header());
        for (String oneString : file.split("\n")) {
            ArrayList<String> arrayString = new ArrayList<>();
            for (String val : oneString.split("\t")) {
                arrayString.add(val);
            }
            answerArray.add(arrayString);
        }
        return answerArray;
    }

    private static String vcf_to_html(String fileName) throws IOException {
        StringBuffer html = new StringBuffer();
        StringBuffer file = readUsingBufferedReader(fileName);
        html.append(
                "<!DOCTYPE HTML>\n" +
                        "<html xmlns:th=\"http://www.thymeleaf.org\">\n" +
                        "<link rel=\"stylesheet\" type=\"text/css\" href=\"webjars/bootstrap/3.3.7/css/bootstrap.min.css\" />\n" +
                        "<link rel=\"stylesheet\" th:href=\"@{/css/style.css}\" href=\"../../css/style.css\" />\n" +
                        "<head>\n" +
                        "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/>\n" +
                        "</head>\n" +
                        "<body>\n" +
                        "<a href=\"/\"  class = \"button\" >Start page</a>\n"
        );


        //making table
        html.append(
                "<table>\n" +
                        "  <tr>\n" +
                        TABLE_STRUCTURE +
                        "</tr>\n" +
                        "<tr>\n" +
                        "    <td>"
        );
        html.append(replaceBuf(replaceBuf(readUsingBufferedReader(fileName), "\n", "</td>\n</tr>\n<tr>\n<td>"), "\t", "</td> <td>"));
        html.append(
                "</td>\n" +
                        "</tr>\n" +
                        "</table>\n"
        );


        html.append("</body>\n");

        return html.toString();
    }

    private static void whenWriteStringUsingBufferedWritter_thenCorrect(String outputFileName, String output)
            throws IOException {
        System.out.println(outputFileName);
        File file = new File(outputFileName);
        System.out.println(file.exists());
        BufferedWriter writer = new BufferedWriter(new FileWriter(outputFileName));
        writer.write(output);
        writer.close();
    }

    public static ArrayList<ArrayList<String>> runVcfToTable(String vcfFile) throws IOException {
        String vcfFilePath = System.getProperty("user.dir") + "/src/main/python/" + vcfFile;
//        String outputHTMLPath = System.getProperty("user.dir") + "/src/main/resources/templates/output_tables/" + vcfFile + ".html";
//        String output = new String(vcf_to_html(vcfFilePath));
//        whenWriteStringUsingBufferedWritter_thenCorrect(outputHTMLPath, output);
//        return vcfFile + ".html";
        ArrayList<ArrayList<String>> tableOutput = vcf_to_array(vcfFilePath);
        return tableOutput;
    }


}
