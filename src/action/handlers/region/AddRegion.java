package action.handlers.region;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AddRegion extends GatewayAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			Region region = new Region();
			region.setName(request.getParameter("name"));
			region.setPopulation(Integer.valueOf(request.getParameter("population")));
			region.setSquare(Integer.valueOf(request.getParameter("square")));
			region.setParentID(Integer.valueOf(request.getParameter("parent_id")));
		
			getGateway().add(region);

			response.sendRedirect("region/showAll.jsp?success=true");
		}
		catch (Exception e) {
			try {
				response.sendRedirect("error.jsp");
			}
			catch (Exception ex) {
				
			}
		}
	}
}