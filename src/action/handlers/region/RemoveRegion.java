package action.handlers.region;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RemoveRegion extends GatewayAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			Gateway gateway = getGateway();
			int id = Integer.valueOf(request.getParameter("id"));
			Region region = (Region) gateway.get(id);
			gateway.remove(region);
	
			response.sendRedirect("/WebPrototype/region/showAll.jsp?success=true");
		}	
		catch (Exception e) {
			try {
				response.sendRedirect("/WebPrototype/error.jsp?message=" + e.getMessage());
			}
			catch (Exception ex) {
				
			}
		}
	}
}