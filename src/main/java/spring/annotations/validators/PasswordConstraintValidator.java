package spring.annotations.validators;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import org.springframework.beans.BeanWrapperImpl;

import spring.annotations.ValidPassword;

public class PasswordConstraintValidator implements ConstraintValidator<ValidPassword, Object> {

	private String field;
	private String fieldMatch;
	private String message;

	public void initialize(ValidPassword constraintAnnotation) {
		this.field = constraintAnnotation.field();
		this.fieldMatch = constraintAnnotation.fieldMatch();
		this.message = constraintAnnotation.message();
	}

	public boolean isValid(Object value, ConstraintValidatorContext context) {
		Object fieldValue = new BeanWrapperImpl(value).getPropertyValue(field);
		Object fieldMatchValue = new BeanWrapperImpl(value).getPropertyValue(fieldMatch);
		boolean isValid = fieldValue != null && fieldValue.equals(fieldMatchValue);
		if (!isValid) {
			context.disableDefaultConstraintViolation();
			context.buildConstraintViolationWithTemplate(message).addPropertyNode(fieldMatch).addConstraintViolation();
		}
		return isValid;
	}
}
