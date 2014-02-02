package tui;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import used.City;
import used.Country;
import used.DataBase;
import used.Region;

public class Controller extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private DataBase db = new DataBase();
	private Object ret;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String list = request.getParameter("list");
		String filter = request.getParameter("filter");
		String parent = request.getParameter("parent");
		
		if("countries".equals(list)) {
			if("all".equals(filter)) {
				ret = db.getCountries();
			}
		}
		
		if("children".equals(list)) {
			boolean found = false;
			for(Country c:db.getCountries()) {
				if(c.getName().equals(parent)) {
					ret = c.getRegs();
					found = true;
				}
			}
			
			if(!found) {
				for(Country c:db.getCountries()) {
					for(Region r:c.getRegs()) {
						if(r.getName().equals(parent)) {
							ret = r.getCities();
							found = true;
						}
					}
				}
			}
			
			if(!found) {
				for(Country c:db.getCountries()) {
					for(Region r:c.getRegs()) {
						for(City cit:r.getCities()) {
							if(cit.getName().equals(parent)) {
								ret = cit.getUnis();
								found = true;
							}
						}
					}
				}
			}
		}
		
		request.setAttribute("data", ret);
		request.getRequestDispatcher("display.jsp").forward(request, response);
	}
}
