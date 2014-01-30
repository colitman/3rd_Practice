package action.handlers.university;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RemoveUniversity extends GatewayAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			int id = Integer.valueOf(request.getParameter("id"));
			Gateway gateway = getGateway();
			University university = (University) gateway.get(id);
			gateway.remove(university);
				
			response.sendRedirect("/WebPrototype/university/showAll?success=true");
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