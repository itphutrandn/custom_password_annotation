package spring.model;


import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Size;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import spring.annotations.ValidPassword;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ValidPassword.List({ 
	@ValidPassword(
      field = "password", 
      fieldMatch = "confirmPassword", 
      message = "Passwords do not match!"
    ), 
	@ValidPassword(
      field = "email", 
      fieldMatch = "confirmEmail", 
      message = "Email addresses do not match!"
    )
})
public class User {
	
	@NotEmpty(message = "vui lòng nhập name " ) 
	@Size(min = 6 ,max = 32 , message = "vui lòng nhập ít nhất 6 kí tự và nhiều nhất 3 2 kí tự" )
	
	private String username;

	@Size(min = 6,message = "vui lòng nhập vào ít nhất 6 kí tự")
	private String password;
	
	private String confirmPassword;
	
	@NotEmpty(message = "Vui lòng nhập vào họ tên ")
	private String hoten;
	
	@Email(message = "vui lòng nhập vào email đúng dạng")
	@NotEmpty(message = "vui lòng nhập vào email")
	private String email;
	
	@Email
	private String confirmEmail;
	
	@NotEmpty(message = "Vui lòng chọn giới tính")
	private String gioitinh;
	
	@NotEmpty(message = "Vui lòng chọn thành phố")
	private String thanhpho;
	private String yahoo;
	@NotEmpty(message = "Vui lòng nhập nick skype")
	private String skype;
	
	@NotEmpty(message = "Vui lòng giới thiệu ")
	private String gioithieu;
}
