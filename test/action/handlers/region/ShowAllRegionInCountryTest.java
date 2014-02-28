package action.handlers.region;

import static org.junit.Assert.*;
import org.junit.*;
import action.*;
import hibernate.logic.*;
import util.*;
import util.gateway.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShowAllRegionInCountryTest {

	@Test(expected = NullPointerException.class)
	public void nullTest() throws Exception {
		Utils.perform("showAllRegionInCountry", null, null);
	}

	@Test(expected = ActionException.class)
	public void actionExceptionTest() throws Exception {
		RegionListGateway gateway = new RegionListGateway();
	
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

		Utils.perform("showAllRegionInCountry", request, new ServletResponseSkeleton());
	}

	@Ignore
	@Test
	public void logicTest() throws Exception {
		RegionListGateway gateway = new RegionListGateway();

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

		Utils.perform("addRegion", request, response);
		Utils.perform("addRegion", request, response);
		Utils.perform("addRegion", request, response);

		assertEquals(3, gateway.size());

		Utils.perform("showAllRegionInCountry", request, response);
		
		assertEquals(2, gateway.size());
	}

	@Test
	public void forwardTest() throws Exception {
		RegionListGateway gateway = new RegionListGateway();

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

		Utils.perform("addRegion", request, response);	

		String url = Utils.perform("showAllRegionInCountry", request, response);
		
		if (!url.contains("showAllInCountry")) {
			fail("forward must contains <showAllInCountry>"); 
		}
	}
}