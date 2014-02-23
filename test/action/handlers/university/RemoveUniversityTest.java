package action.handlers.university;

import org.junit.*;
import action.*;
import hibernate.logic.*;
import util.*;
import util.gateway.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RemoveUniversityTest extends Assert {

	@Test(expected = NullPointerException.class)
	public void nullTest() throws Exception {
		Utils.perform("removeUniversity", null, null);
	}

	@Test(expected = ActionException.class)
	public void actionExceptionTest() throws Exception {
		UniversityListGateway gateway = new UniversityListGateway();
	
		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {
					case "id" : return "bla";
					case "parent_id" : return "zaza";
				}
				return null;
			}
		};

		Utils.perform("removeUniversity", request, new ServletResponseSkeleton());
	}

	@Test
	public void logicTest() throws Exception {
		UniversityListGateway gateway = new UniversityListGateway();

		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {
					case "name" : return "skeleton";
					case "departs_count" : return "10";
					case "www" : return "zzz";
					case "id" : return "6";
					case "parent_id" : return "3";
				}
				return null;
			}
		};
		HttpServletResponse response = new ServletResponseSkeleton();

		assertEquals(0, gateway.size());

		Utils.perform("addUniversity", request, response);
		Utils.perform("addUniversity", request, response);
		Utils.perform("addUniversity", request, response);

		assertEquals(3, gateway.size());

		Utils.perform("removeUniversity", request, response);
		
		assertEquals(2, gateway.size());
	}

	@Test
	public void forwardTest() throws Exception {
		UniversityListGateway gateway = new UniversityListGateway();

		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {
					case "name" : return "skeleton";
					case "departs_count" : return "10";
					case "www" : return "zzz";
					case "id" : return "1";
					case "parent_id" : return "3";
				}
				return null;
			}
		};
		
		HttpServletResponse response = new ServletResponseSkeleton();

		Utils.perform("addUniversity", request, response);	

		String url = Utils.perform("removeUniversity", request, response);
		
		if (!url.contains("showAllUniversity")) {
			fail("forward must contains <showAllUniversity>"); 
		}
	}
}