package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.security.Principal;
import java.util.List;


public class User implements Principal, Serializable{
	
	private static final long serialVersionUID = 1L;
	private int userId;
	private String userName;
	private String username;
	private String firstName;
	private String lastName;
	private String email;
	@Deprecated private String title;
	private boolean enabled;
	private boolean verified;
	private boolean mailist;
	private boolean contactlist;
	private String organization;
	private String industry;
	private String howdidyouhear;
	private String password;
	private String timezone;
	
	private List<UserRole> userroles;
	private UserSession usersession;
	
	private String delim = ";";
	
	@Override
	public String toString() {
		StringBuilder str = new StringBuilder("USER:");
		str.append("userid=")
		.append(userId)
		.append(delim)
		.append("userName=")
		.append(userName)
		.append(delim)
		.append("firstName=")
		.append(firstName)
		.append(delim)
		.append("lastName=")
		.append(lastName)
		.append(delim)
		.append("title=")
		.append(title)
		.append(delim)
		.append("email")
		.append(email)
		.append(delim)
		.append("enabled")
		.append(enabled)
		.append(delim)
		.append("verified")
		.append(verified)
		.append(delim)
		.append("userroles=")
		.append(userroles)
		.append(delim)
		.append("usersession=")
		.append(usersession);
		
		return str.toString();
		
	}
	

	public User(int userId, String userName, String firstName, String lastName, String title, String email, boolean enabled, boolean verified, List<UserRole> roles, UserSession session){
		this.userId=userId;
		this.userName=userName;
		this.firstName=firstName;
		this.lastName=lastName;
		this.title=title;
		this.email=email;
		this.enabled=enabled;
		this.verified=verified;
		this.userroles=roles;
		this.usersession= session;
		
		
		
	}
	
	public String getName(){
		return userName;
	}
	
	public UserSession getUsersession() {
		return usersession;
	}

	public void setUsersession(UserSession usersession) {
		this.usersession = usersession;
	}

	public List<UserRole> getUserroles() {
		return userroles;
	}

	public void setUserroles(List<UserRole> userroles) {
		this.userroles = userroles;
	}

	public User(String userName){
		this.userName=userName;
	}
	
	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.username = userName;
		this.userName = username;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	
	/**
	 * Default constructor should not be used
	 */
	public User(){
		
	}


	public String getEmail() {
		return email;
	}


	public void setEmail(String email) {
		this.email = email;
	}


	public boolean isEnabled() {
		return enabled;
	}


	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}


	public boolean isVerified() {
		return verified;
	}


	public void setVerified(boolean verified) {
		this.verified = verified;
	}


	public boolean isMailist() {
		return mailist;
	}


	public void setMailist(boolean mailist) {
		this.mailist = mailist;
	}


	public boolean isContactlist() {
		return contactlist;
	}


	public void setContactlist(boolean contactlist) {
		this.contactlist = contactlist;
	}


	public String getOrganization() {
		return organization;
	}


	public void setOrganization(String organization) {
		this.organization = organization;
	}


	public String getIndustry() {
		return industry;
	}


	public void setIndustry(String industry) {
		this.industry = industry;
	}


	public String getHowdidyouhear() {
		return howdidyouhear;
	}


	public void setHowdidyouhear(String howdidyouhear) {
		this.howdidyouhear = howdidyouhear;
	}


	public String getPassword() {
		return password;
	}


	public void setPassword(String password) {
		this.password = password;
	}


	public String getUsername() {
		return username;
	}


	public void setUsername(String username) {
		this.username = username;
		this.userName = username;
	}
	

	public String getTimezone() {
		return timezone;
	}

	public void setTimezone(String timezone) {
		this.timezone = timezone;
	}

	public int hashCode(){
		return userName.hashCode();
	}
	
	public boolean equals(Object o){
		if (o ==null){
			return false;
		}
		
		if (! ( o instanceof User)){
			return false;
		}
		
		User that = (User) o;
		if (this.getName().equals(that.getName())){
			return true;
		}
		
		return false;
	}

}
