package com.example.WebApp.user;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;


import java.nio.file.Path;
import org.springframework.ui.Model;

import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.activation.*;
import java.io.*;
import java.net.MalformedURLException;
import java.nio.file.Files;

import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@Controller
public class UserController {

    private static String UPLOADED_FOLDER = "/var/www/WebApp/src/main/uploads/";

    @GetMapping("")
    public String homePage(){
        return "homepage";
    }

    @GetMapping("/register")
    public String signUpFormGET(){
        return "under";
    }

    @RequestMapping(value = "/upload", method = RequestMethod.GET)
    public String UploadFormGet(){
        return "upload";
    }

    @RequestMapping(value = "/show_image", method = RequestMethod.GET)
    public ResponseEntity getImage(@RequestParam("img") String name) {
        String fileName = UPLOADED_FOLDER + name;
        Path path = Paths.get(fileName);
        Resource resource = null;
        try {
            resource = new UrlResource(path.toUri());
        } catch (MalformedURLException e){
            e.printStackTrace();
        }
        return ResponseEntity.ok().contentType(MediaType.IMAGE_JPEG).body(resource);
    }

    @PostMapping("/upload")
    public String Upload(@RequestParam("file") MultipartFile file, Model model){
        String fileName = StringUtils.cleanPath(file.getOriginalFilename());
        if (!file.isEmpty() && !fileName.contains("/")){
            String mimetype = new MimetypesFileTypeMap().getContentType(fileName);
            String type = mimetype.split("/")[0];
            if (type.equals("image")){

                try {
                    Path path = Paths.get(UPLOADED_FOLDER+fileName);
                    Files.copy(file.getInputStream(),path, StandardCopyOption.REPLACE_EXISTING);
                } catch (IOException e){
                    e.printStackTrace();
                }
                model.addAttribute("name", fileName);
                model.addAttribute("message", "Uploaded!");
            } else {
                model.addAttribute("message", "Only image files are accepted!");
            }
            
        } else {
            model.addAttribute("message", "Please Upload a file!");
        }
        return "upload";
    }

    @GetMapping("/release_notes")
    public String changelog(){
        return "change";
    }

    @GetMapping("/blogs")
    public String blogPage(){
        return "blog";
    }
    
}
