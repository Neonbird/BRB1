package app.requests;

import app.tables.VcfToTable;
import app.workscript.ScriptPython;
import lombok.Getter;
import lombok.Setter;

import java.io.IOException;
import java.util.ArrayList;

public class CalculateRequest {

    @Setter
    @Getter
    private String script;
    @Setter
    @Getter
    private String file;

    public ArrayList<ArrayList<String>> createAnswer() throws IOException {
        script = "script_python.py";
        ScriptPython scriptPython = new ScriptPython();
        String answer = scriptPython.runScript(new String[]{file}, script);
        System.out.println(answer+"kkk");
        System.out.println(file+"fileeeeee");
//        String answer = scriptPython.runScript(new String[]{file.getOriginalFilename()}, "ukb_phewas/LSEA/LSEA.py", "-af ./PCscore_2_exact_5.tsv -sn ./snpEff/ -pld ./plink-ng/1.9 -bf ./1000G/EUR_1KG_nodups -p");
        //todo поменять имя на то, что в реале выдает
        return VcfToTable.runVcfToTable(file+".vcf");

    }


}
