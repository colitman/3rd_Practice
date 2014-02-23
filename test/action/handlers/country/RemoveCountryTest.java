package action.handlers.country;

import org.junit.*;
import action.*;
import hibernate.logic.*;
import util.*;
import util.gateway.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RemoveCountryTest extends Assert {

	@Test(expected = NullPointerException.class)
	public void nullTest() throws Exception {
		Utils.perform("removeCountry", null, null);
	}

	@Test(expected = ActionException.class)
	public void actionExceptionTest() throws Exception {
		CountryListGateway gateway = new CountryListGateway();
	
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

		Utils.perform("removeCountry", request, new ServletResponseSkeleton());
	}

	@Test
	public void logicTest() throws Exception {
		CountryListGateway gateway = new CountryListGateway();

		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {
					case "name" : return "skeleton";
					case "capital" : return "ZZZ";
					case "language" : return "zzz";
					case "population" : return "100";
					case "timezone" : return "1";
					case "id" : return "6";
					case "parent_id" : return "3";
				}
				return null;
			}
		};
		HttpServletResponse response = new ServletResponseSkeleton();

		assertEquals(0, gateway.size());

		Utils.perform("addCountry", request, response);
		Utils.perform("addCountry", request, response);
		Utils.perform("addCountry", request, response);

		assertEquals(3, gateway.size());

		Utils.perform("removeCountry", request, response);
		
		assertEquals(2, gateway.size());
	}

	@Test
	public void forwardTest() throws Exception {
		CountryListGateway gateway = new CountryListGateway();

		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {
					case "name" : return "skeleton";
					case "capital" : return "ZZZ";
					case "language" : return "zzz";
					case "population" : return "100";
					case "timezone" : return "1";
					case "id" : return "1";
					case "parent_id" : return "3";
				}
				return null;
			}
		};
		
		HttpServletResponse response = new ServletResponseSkeleton();

		Utils.perform("addCountry", request, response);	

		String url = Utils.perform("removeCountry", request, response);
		
		if (!url.contains("showAllCountry")) {
			fail("forward must contains <showAllCountry>"); 
		}
	}
}