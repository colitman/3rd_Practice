package action.handlers.region;

import static org.junit.Assert.*;
import org.junit.*;
import action.*;
import hibernate.logic.*;
import util.*;
import util.gateway.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AddRegionTest {

	@Test(expected = NullPointerException.class)
	public void nullTest() throws Exception {
		Utils.perform("addRegion", null, null);
	}

	@Test(expected = ActionException.class)
	public void actionExceptionTest() throws Exception {
		RegionListGateway gateway = new RegionListGateway();
	
		GatewayResolver.setGateway(gateway);

		HttpServletRequest request = new ServletRequestSkeleton() {
			@Override
			public String getParameter(String name) {
				switch (name) {
					case "name" : return "skeleton";
					case "population" : return "ZZZ";
					case "square" : return "zzz";
					case "parent_id" : return "zaza";
				}
				return null;
			}
		};
		HttpServletResponse response = new ServletResponseSkeleton();

		Utils.perform("addRegion", request, response);
	}

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
					case "parent_id" : return "3";
				}
				return null;
			}
		};
		HttpServletResponse response = new ServletResponseSkeleton();

		assertEquals(0, gateway.size());

		Utils.perform("addRegion", request, response);

		assertEquals(1, gateway.size());

		Utils.perform("addRegion", request, response);

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
					case "parent_id" : return "3";
				}
				return null;
			}
		};
		
		String url = Utils.perform("addRegion", request, new ServletResponseSkeleton());
		
		if (!url.contains("showAllRegion")) {
			fail("forward must contains <showAllRegion>"); 
		}
	}
}