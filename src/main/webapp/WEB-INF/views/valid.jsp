<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri = "http://www.springframework.org/tags/form"  prefix="form"%>
<html>
	<head>
		<title>Validator | VinaEnter Edu</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="keywords" content="học php" />
		<meta name="description" content="học php" />
	</head>
	<body>
		<p>
			Với Spring dùng thư viện Hibernate Validator, kiểm tra tính hợp lệ dữ liệu người dùng nhập vào form theo yêu cầu sau:</p>			
		<p style="size:90%; font-style:italic">(*) Bắt buộc nhập</p>
		
		<c:if test="${not empty success }">
			${success }
		</c:if>
		<form action="${pageContext.request.contextPath}/valid" method="POST" >
			<form:errors path="userError.*"/> 
			<table width="800px" border="1">
				<tr><td colspan="2"><p style="color:#E97D13; text-align:center">TRUNG TÂM ĐÀO TẠO LẬP TRÌNH VINAENTER</p></td></tr>
				<tr><td colspan="2"><p style="color:#E97D13"><b>Đăng ký thành viên, gian hàng</b></p></td></tr>
				<tr>
					<td width="152px" valign="top">Tên truy cập(*): </td>
					<td valign="top">
					<form:errors cssStyle="color:red;fort-style:italic" path="userError.username"></form:errors><br>
						<input type="text" value="" name="username" size="32" /><br />
					</td>
				</tr>
				
				<tr>
					
					<td valign="top">Mật khẩu(*): </td>
					<td valign="top">
					<form:errors cssStyle="color:red;fort-style:italic" path="userError.password"></form:errors><br>
						<input type="password" value="" name="password" size="32" /><br />
					</td>
				</tr>
				
				<tr>
				
					<td valign="top">Xác nhận mật khẩu(*): </td>
					<td valign="top">
						<input type="password" value="" name="confirmPassword" size="44" /><br />
						<form:errors cssStyle="color:red;fort-style:italic" path="userError.confirmPassword"></form:errors><br>
					</td>
				</tr>
				
				<tr>
					<td valign="top">Họ và tên(*): </td>
					<td valign="top">
						<form:errors cssStyle="color:red;fort-style:italic" path="userError.hoten"></form:errors><br>
						<input type="text" value="" name="hoten" size="44" />
					</td>
				</tr>
				
				<tr>
					<td valign="top">Email(*): </td>
					<td valign="top">
					<form:errors cssStyle="color:red;fort-style:italic" path="userError.email"></form:errors><br>
						<input type="text" value="" name="email" size="44" /><br />
					</td>
				</tr>
				
				<tr>
					<td valign="top">Xác nhận email: </td>
					<td valign="top">
					<form:errors cssStyle="color:red;fort-style:italic" path="userError.confirmEmail"></form:errors><br>
						<input type="text" value="" name="confirmEmail" size="44" /><br />
					</td>
				</tr>
				
				<tr>
					<td valign="top">Giới tính(*): </td>
					<td valign="top">
					<form:errors cssStyle="color:red;fort-style:italic" path="userError.gioitinh"></form:errors><br>
						Nam <input type="radio" value="nam" name="gioitinh" />
						Nữ <input type="radio" value="nu" name="gioitinh" /><br />						
					</td>
				</tr>
				
				<tr>
					<td valign="top">Thành phố(*): </td>
					<td valign="top">
					<form:errors cssStyle="color:red;fort-style:italic" path="userError.thanhpho"></form:errors><br>
						<select name="thanhpho">
							<option value="">--[Chọn]--</option>
							<option value="danang">Đà Nẵng</option>
							<option value="hochiminh">Hồ Chí Minh</option>
							<option value="hanoi">Hà Nội</option>
						</select>
					</td>
				</tr>
				
				<tr>
					<td valign="top">Nick Yahoo: </td>
					<td valign="top">
					<form:errors cssStyle="color:red;fort-style:italic" path="userError.thanhpho"></form:errors><br>
						<input type="text" value="" name="yahoo" />
					</td>
				</tr>
				
				<tr>
					<td valign="top">Nick Skype(*): </td>
					<td valign="top">
					<form:errors cssStyle="color:red;fort-style:italic" path="userError.skype"></form:errors><br>
						<input type="text" value="" name="skype" />
					</td>
				</tr>
				
				<tr>
					<td valign="top">Giới thiệu thành viên(*)</td>
					<td valign="top">
						<textarea rows="6" cols="80" name="gioithieu"></textarea>
					</td>
				</tr>
				
				<tr>
					<td valign="top">&nbsp;</td>
					<td valign="top">
						<input type="submit" value="Submit" name="submit" />
					</td>
				</tr>
				
			</table>
		</form>
	</body> 
</html> 