# Custom password Annotation in Spring MVC
Validating data is a very important and critical task and should be implemented very well in every application. Spring Boot provides already nice and easy to use annotations, that can be used for all kinds of basic validations. However, when you work with these validations, then you will most likely reach a point, where you cannot find an appropriate annotation that provides out of the box checks that you need for some special edge cases.

Therefore, in this post, we will show you how you can implement your own custom validation annotations and how to assign the error messages to the right fields. As an example we will implement two validators. The first validation will check if a password follows all requested rules. The second validation will check if the password and its confirmation field are the same.

Step 1 - The Annotation Interface
The starting point when creating a new custom Spring Boot validation annotation is the interface. It defines how the annotation is called, some parameters that can be defined when using it and the validator class, that performs the actual check.

package it.aboutbits.support.validation;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.ANNOTATION_TYPE;
import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

@Documented
@Constraint(validatedBy = ValidPasswordValidator.class)
@Target({FIELD, ANNOTATION_TYPE})
@Retention(RUNTIME)
public @interface ValidPassword {
    String message() default "The password does not comply with the rules.";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
The name of the interface defines also the name of the annotation. Here we call the annotation ValidPassword.

Next, the field message defines a parameter, that can be used by the user to pass some information to the validator. This will be shown in more detail later on.

The @Constraint annotation above the class defines the actual validator implementation. The ValidPasswordValidator class will be used for the checks.

Step 2 - The Validator Class
As a next step, we have to implement the already previously referenced validator class, which is responsible for checking the data.

package it.aboutbits.support.validation;

import org.apache.commons.lang3.StringUtils;
import org.passay.LengthRule;
import org.passay.PasswordData;
import org.passay.PasswordValidator;
import org.passay.WhitespaceRule;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.List;

public class ValidPasswordValidator implements ConstraintValidator<ValidPassword, String> {

    private String message;

    @Override
    public void initialize(final ValidPassword constraintAnnotation) {
        this.message = constraintAnnotation.message();
    }

    @Override
    public boolean isValid(final String password, final ConstraintValidatorContext context) {

        PasswordValidator validator = new PasswordValidator(List.of(
                // at least 8 characters
                new LengthRule(8, 50)
        ));

        boolean isValid = StringUtils.isNotBlank(password) && validator.validate(new PasswordData(password)).isValid();

        if (!isValid) {
            context.disableDefaultConstraintViolation();
            context.buildConstraintViolationWithTemplate(message).addConstraintViolation();
        }

        return isValid;
    }
}
As you can see from the example, the field message is here now available to the validator. The validator can read it out in the initialization phase (initialize) and access the variable later on in the validation phase (isValid).

The input value of the field from the object under validation is available as a first parameter passed to the validation method. You can now implement here all checks you want.

The method should return true for valid data and false for invalid data.

Sometimes the default ConstraintValidationException doesn't communicate the error to the user very well. Often you want also provide to the user some hints about what is wrong. Here Spring Boot provides also a context object, that is passed to the isValid method. Using this context object, we have the possibility to pass some messages to the user by placing a message for a specific field/variable.

Step 3 - Checking the Data
Last, we have to add the annotation to our validated object. In this example we validate the request body of a typical password change operation.

package it.aboutbits.rest.user.request;

import it.aboutbits.support.validation.ConfirmedField;
import it.aboutbits.support.validation.ValidPassword;
import lombok.Data;

@Data
@ConfirmedField(originalField = "newPassword", confirmationField = "newPasswordConfirmation")
public class ChangePasswordBody {
    private String oldPassword;
    @ValidPassword
    private String newPassword;
    private String newPasswordConfirmation;
}
As we can see in the example, the annotation is placed above the variable and so the validation will be executed for this field.

Inside the controller, we can then reference this request object.

package it.aboutbits.rest.user;

import it.aboutbits.rest.user.request.ChangePasswordBody;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;

@RestController
@RequestMapping("/app/v1/profile")
@Tag(name = "Profile API")
@RequiredArgsConstructor
@Validated
public class ProfileController {
    @PutMapping("/password")
    @Operation(summary = "Change password of logged in user.")
    public void changePassword(final @Valid @RequestBody ChangePasswordBody body) {
        ...
    }
}

Here two things are important. First, the annotation @Validated has to be added to the controller. And second, the @Valid annotation has to be put in front of the request. Like this, Spring Boot picks up all the data and validates it before passing it on to the actual code of the method. If there is an error in the data, then the actual code will never be reached.

Validating two fields together
The approach described above highlights a check that requires only one field for the analysis. But sometimes validations require checking two or more fields together.

To also show how you could implement such a custom validation for multiple fields, we will pick up the ConfirmedField annotation already applied above and show how to create this validator.

Therefore, also here we first have to create the interface:

package it.aboutbits.support.validation;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import static java.lang.annotation.RetentionPolicy.RUNTIME;

@Target(ElementType.TYPE)
@Retention(RUNTIME)
@Constraint(validatedBy = ConfirmedFieldValidator.class)
@Documented
public @interface ConfirmedField {

    String message() default "Doesn't match the original";

    String originalField();

    String confirmationField();

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    @Target({ElementType.TYPE})
    @Retention(RetentionPolicy.RUNTIME)
    @interface List {
        ConfirmedField[] value();
    }
}
Here we can see that in addition to the message parameter also other parameters are required. These are called originalField and confirmationField. In the example above, where the validator is attached to the request, we can see how these two parameters are defined and passed to the validation.

Another important point to note is, that this validator is attached to the whole request class and not only to a single variable. This allows us to access not only the value of one single field, but all the variables of the class. This way we can compare if the two fields are the equal. However, we have to tell the validator which fields we want to compare and that's why we have to define the originalField and the confirmationField.

package it.aboutbits.support.validation;

import org.springframework.beans.BeanWrapperImpl;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class ConfirmedFieldValidator implements ConstraintValidator<ConfirmedField, Object> {

    private String originalField;
    private String confirmationField;
    private String message;

    public void initialize(final ConfirmedField constraintAnnotation) {
        this.originalField = constraintAnnotation.originalField();
        this.confirmationField = constraintAnnotation.confirmationField();
        this.message = constraintAnnotation.message();
    }

    public boolean isValid(final Object value, final ConstraintValidatorContext context) {
        Object fieldValue = new BeanWrapperImpl(value).getPropertyValue(originalField);
        Object fieldMatchValue = new BeanWrapperImpl(value).getPropertyValue(confirmationField);

        boolean isValid = fieldValue != null && fieldValue.equals(fieldMatchValue);

        if (!isValid) {
            context.disableDefaultConstraintViolation();
            context
                    .buildConstraintViolationWithTemplate(message)
                    .addPropertyNode(confirmationField)
                    .addConstraintViolation();
        }

        return isValid;
    }
}
As you can see from the example, the fields originalField, confirmationField and message are now available to the validator. The validator can read them out in the initialization phase (initialize) and check them later on in the validation phase (isValid).

The input value of the field from the object under validation is available as a first parameter passed to the validation method. Using this object, we can get the values of the inputs of the two fields and check if they are equal.

Also adding the message is a bit different, because we have to tell Spring Boot to add the message to the confirmation field. This way the user will see the error message nearby the confirmation field.

Conclusion
Custom validations allow you to extend the existing validations provided by Spring Boot and offer a nice and easy to use approach to validate the data for custom edge cases in the same way.

In addition, the context of the current object can be used to pass custom error messages to the right fields to give the users more context about the wrong input.
