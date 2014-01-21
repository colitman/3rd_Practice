package action.handlers.city;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RemoveCity extends GatewayAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			int id = Integer.valueOf(request.getParameter("id"));
			Gateway gateway = getGateway();
			City city = (City) gateway.get(id);
			getGateway().remove(city);

			response.sendRedirect("city/showAll.jsp?success=true");
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