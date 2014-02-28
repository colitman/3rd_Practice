package action.handlers.city;

import static org.junit.Assert.*;
import org.junit.*;
import action.*;
import hibernate.logic.*;
import util.*;
import util.gateway.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ModifyCityTest {

	@Test(expected = NullPointerException.class)
	public void nullTest() throws Exception {
		Utils.perform("modifyCity", null, null);
	}

	@Test(expected = ActionException.class)
	public void actionExceptionTest() throws Exception {
		CityListGateway gateway = new CityListGateway();
	
		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {
					case "id" : return "zz";
					case "name" : return "skeleton";
					case "population" : return "ZZZ";
					case "square" : return "zzz";
					case "parent_id" : return "zaza";
				}
				return null;
			}
		};
		HttpServletResponse response = new ServletResponseSkeleton();

		Utils.perform("modifyCity", request, response);
	}

	@Test
	public void logicTest() throws Exception {
		CityListGateway gateway = new CityListGateway();

		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {	
					case "id" : return "10";
					case "name" : return "skeleton";
					case "population" : return "1000";
					case "square" : return "0";
					case "parent_id" : return "3";
				}
				return null;
			}
		};
		HttpServletResponse response = new ServletResponseSkeleton();

		assertEquals(0, gateway.size());

		Utils.perform("addCity", request, response);
		Utils.perform("addCity", request, response);
		Utils.perform("addCity", request, response);

		assertEquals(3, gateway.size());

		Utils.perform("modifyCity", request, response);

		assertEquals(3, gateway.size());
	}

	@Test
	public void forwardTest() throws Exception {
		CityListGateway gateway = new CityListGateway();

		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {
					case "id" : return "1";
					case "name" : return "skeleton";
					case "population" : return "1000";
					case "square" : return "0";
					case "parent_id" : return "3";
				}
				return null;
			}
		};
		
		String url = Utils.perform("addCity", request, new ServletResponseSkeleton());
		
		if (!url.contains("showAllCity")) {
			fail("forward must contains <showAllUniversity>"); 
		}
	}
}