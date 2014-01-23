package action.handlers.country;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AddCountry extends GatewayAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			Country country = new Country();
			country.setName(request.getParameter("name"));
			country.setLanguage(request.getParameter("language"));
			country.setCapital(request.getParameter("capital"));
			country.setPopulation(Integer.valueOf(request.getParameter("population")));
			country.setTimezone(Integer.valueOf(request.getParameter("timezone")));
		
			getGateway().add(country);
			
			response.sendRedirect("country/showAll.jsp?success=true");
		} 	
		catch (Exception e) {
			try {
				response.sendRedirect("error.jsp?message=" + e.getMessage());
			}
			catch (Exception ex) {
				
			}
		}	
	}
}