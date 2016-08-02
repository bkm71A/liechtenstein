package com.incheck.ng.service;


/**
 * An exception that is thrown by classes wanting to trap unique 
 * constraint violations.  This is used to wrap Spring's 
 * DataIntegrityViolationException so it's checked in the web layer.
 *

 */
public class UserSaveException extends Exception {
    private static final long serialVersionUID = 4050482305178810162L;

    /**
     * Constructor for UserSaveException.
     *
     * @param message exception message
     */
    public UserSaveException(final String message) {
        super(message);
    }
}
