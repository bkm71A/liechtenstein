package com.incheck.ng.test;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation that provides a mechanism for defining test data source
 * 
 * @author Bertrand Liechtenstein
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Inherited
@Documented
public @interface TestDataDefinition {
    String dataSetXML() default "test-dataset.xml";
    String dataSetDTD() default "test-dataset.dtd";
}
