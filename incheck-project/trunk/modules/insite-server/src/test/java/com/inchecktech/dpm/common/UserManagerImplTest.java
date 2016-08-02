package com.inchecktech.dpm.common;

import com.inchecktech.dpm.utils.HashUtil;

public class UserManagerImplTest {

	public static void main(String[] args) throws Exception {
		UserManager um = new UserManagerImpl();
		RoleManager rm = new RoleManagerImpl();
		
		//int testIncrement = 2;
		
//		User user = new User();
//		user.setUserName("jbelcher");
//		user.setFirstName("John");
//		user.setLastName("Belcher");
//		user.setEmail("jbelcher@solarpowerindustries.com");
//		user.setContactlist(true);
//		user.setEnabled(true);
//		user.setVerified(true);
//		user.setMailist(false);
//		user.setHowdidyouhear("Radio2");
//		user.setIndustry("Tech2");
//		user.setOrganization("john");
//		user.setPassword("password2");
//		
//		List<UserRole> roles = rm.getRoles();
//		List<UserRole> roless = new ArrayList<UserRole>();
//		roless.add(roles.get(1));
//		roless.add(roles.get(2));
//		user.setUserroles(roless);
		
		//Status status = um.createUser(user);
		//Status status = um.updateUser(user);
		
		//Status status = um.updateUserPass("sjames", "spijames123");
		//System.out.println(status.getMessage());
		
		
		String passwordHash = HashUtil.hashString("bearing709");
		System.out.println(passwordHash);
		
		
		// System.out.println(rm.createRole("TestRoleName", "TestRoleDesc"));
		// System.out.println(rm.getRoles());
		//		
		// um.removeUserFromRole("ykhazanov", "admin");
		// um.addUserToRole("ykhazanov", "admin");
		// System.out.println(um.createUser("vgusev", "password", "Vlad",
		// "Gusev","vlad.gusev@gmail.com", "InCheck", "Technology", "Article",
		// true, true, true));

		// System.out.println(um.getRolesForUser("ykhazanov"));
	}

}
