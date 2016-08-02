package com.slava.tests.workspace_save;

import java.math.BigDecimal;

public class ComaMaxValidation {
    private static final int COMA_MAX_DECIMAL_PLACES = 2;
    private static final int COMA_MAX_DECIMAL_DIGITS = 12;
    private static final long COMA_MAX_PAYMENT_AMOUNT = new BigDecimal(1).movePointRight(COMA_MAX_DECIMAL_DIGITS).longValue() - 1;

    /**
     * @see ComaService#checkValidComaAmount(java.math.BigDecimal)
     */
    public void checkValidComaAmount(BigDecimal number) {
        if (!isAmountValid(number)) {
            System.out.println("Invalid payment amount '" + number + "' (amount too large, maximum allowed is '" + COMA_MAX_PAYMENT_AMOUNT + "').");
        }      else{
            System.out.println("OK : "+number);
        }
    }

    private static boolean isAmountValid(BigDecimal number) {
        return number.longValue() <= COMA_MAX_PAYMENT_AMOUNT;
    }

    public ComaMaxValidation() {
    }

    public static void main(String[] args) {
        ComaMaxValidation test = new ComaMaxValidation();
        test.checkValidComaAmount(new BigDecimal("999999999.98"));
        test.checkValidComaAmount(new BigDecimal("999999999.99"));
        test.checkValidComaAmount(new BigDecimal("999999999.991"));
        test.checkValidComaAmount(new BigDecimal("1111999999999.98"));
    }
}
