package com.incheck.ng.dao;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.transaction.annotation.Transactional;

import com.incheck.ng.model.User;

/**
 * User Data Access Object (GenericDao) interface.
 *
 */
public interface UserDao extends GenericDao<User, Long> {

    /**
     * Gets users information based on login name.
     * @param username the user's username
     * @return userDetails populated userDetails object
     * @throws org.springframework.security.core.userdetails.UsernameNotFoundException thrown when user not
     * found in database
     */
    @Transactional
    UserDetails loadUserByUsername(String username) throws UsernameNotFoundException;

    /**
     * Gets a list of users ordered by the uppercase version of their username.
     *
     * @return List populated list of users
     */
    List<User> getUsers();

    /**
     * Saves a user's information.
     * @param user the object to be saved
     * @return the persisted User object
     */
    User saveUser(User user);

    /**
     * Retrieves the password in DB for a user
     * @param username the user's username
     * @return the password in DB, if the user is already persisted
     */
    String getUserPassword(String username);
}
