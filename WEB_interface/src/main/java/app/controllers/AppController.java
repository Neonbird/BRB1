package app.controllers;

import app.responses.*;
import app.requests.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.view.RedirectView;

import java.io.IOException;
import java.util.ArrayList;


@RestController
@RequestMapping("/")
public class AppController {

    public AppController() {
    }


    @GetMapping
    public RedirectView redirectToIndex() {
        return new RedirectView("/index.html");
    }

    @PostMapping("/calculate")
    public BaseResponse calculate(@RequestBody CalculateRequest calculateRequest) throws IOException {
        ArrayList<ArrayList<String>> answer = calculateRequest.createAnswer();
        return new BaseResponse(200, answer);
    }




    @PostMapping("/ok")
    public BaseResponse ok(){
        return new BaseResponse(200,"ok");
    }
    @PostMapping("/err")
    public BaseResponse err(){
        return new BaseResponse(400,"error");
    }
}
