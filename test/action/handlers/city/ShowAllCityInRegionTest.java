package action.handlers.city;

import static org.junit.Assert.*;
import org.junit.*;
import action.*;
import hibernate.logic.*;
import util.*;
import util.gateway.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShowAllCityInRegionTest {

	@Test(expected = NullPointerException.class)
	public void nullTest() throws Exception {
		Utils.perform("showAllCityInRegion", null, null);
	}

	@Test(expected = ActionException.class)
	public void actionExceptionTest() throws Exception {
		CityListGateway gateway = new CityListGateway();
	
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

		Utils.perform("showAllCityInRegion", request, new ServletResponseSkeleton());
	}

	@Ignore
	@Test
	public void logicTest() throws Exception {
		CityListGateway gateway = new CityListGateway();

		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {
					case "name" : return "skeleton";
					case "population" : return "1000";
					case "square" : return "0";
					case "id" : return "6";
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

		Utils.perform("showAllCityInRegion", request, response);
		
		assertEquals(2, gateway.size());
	}

	@Test
	public void forwardTest() throws Exception {
		CityListGateway gateway = new CityListGateway();

		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {
					case "name" : return "skeleton";
					case "population" : return "1000";
					case "square" : return "0";
					case "id" : return "1";
					case "parent_id" : return "3";
				}
				return null;
			}
		};
		
		HttpServletResponse response = new ServletResponseSkeleton();

		Utils.perform("addCity", request, response);	

		String url = Utils.perform("showAllCityInRegion", request, response);
		
		if (!url.contains("showAllInRegion")) {
			fail("forward must contains <showAllInRegion>"); 
		}
	}
}