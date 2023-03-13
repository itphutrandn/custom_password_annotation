package spring.controller;

import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import spring.model.User;

@Controller
public class ValidController {
	
	@GetMapping("valid")
	public String valid() {
		return"valid";
	}
	
	@PostMapping("valid")
	public String valid(@Valid @ModelAttribute("userError") User user,BindingResult rs,Model model) {
		if(rs.hasErrors() ) {	
			
			for (Object object : rs.getAllErrors()) {
			    if(object instanceof FieldError) {
			        FieldError fieldError = (FieldError) object;
			        System.out.println(fieldError.getRejectedValue());
			    }
			}
			
			return"valid";
		}
		
		model.addAttribute("success","Đăng kí thành công");
		return"valid";
		
	}
	
}
