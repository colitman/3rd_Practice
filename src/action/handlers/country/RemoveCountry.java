package action.handlers.country;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RemoveCountry extends GatewayAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			int id = Integer.valueOf(request.getParameter("id"));
			Gateway gateway = getGateway();
			Country country = (Country) gateway.get(id);
			gateway.remove(country);

			response.sendRedirect("country/showAll.jsp?success=true");
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