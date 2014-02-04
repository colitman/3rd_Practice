package servlet;

import hibernate.logic.*;
import hibernate.dao.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.io.*;
import java.util.*;
import org.apache.log4j.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;

public class ShowServlet extends HttpServlet {
	
	private static final Logger logger = Logger.getLogger("logger");
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			Object ret = null;

			logger.info("Get parameters from request");

			String list = request.getParameter("list");
			String filter = request.getParameter("filter");
			String parent = request.getParameter("parent");
		
			logger.info("Start looking for entity the desired");

			if("countries".equals(list)) {
				if("all".equals(filter)) {
					ret = getCountries();
					logger.info("Found countries");
				}
			}
		
			if("children".equals(list)) {
				boolean found = false;
				for(Country c: getCountries()) {
					if(c.getName().equals(parent)) {
						ret = getRegions(c);
						found = true;
						logger.info("Found regions");
					}
				}
			
				if(!found) {
					for(Country c: getCountries()) {
						for(Region r: getRegions(c)) {
							if(r.getName().equals(parent)) {
								ret = getCities(r);
								found = true;
								logger.info("Found cities");
							}
						}
					}
				}
			
				if(!found) {
					for(Country c: getCountries()) {
						for(Region r: getRegions(c)) {
							for(City cit: getCities(r)) {
								if(cit.getName().equals(parent)) {
									ret = getUniversities(cit);
									found = true;
									logger.info("Found universities");
								}
							}
						}
					}
				}
			}
		
			request.setAttribute("data", ret);

			logger.info("Set entity to request attributes");
			logger.info("Send forward to display.jsp page");	

			request.getRequestDispatcher("display.jsp").forward(request, response);
		}
		catch (SQLException e) {
			logger.error("SQLException occured in ShowServlet", e);
		}
	}

	private Collection<Country> getCountries() throws SQLException {
		return ((OracleGateway<Country>) getGateway()).getAll(Country.class);
	}

	private Collection<Region> getRegions(Country c) throws SQLException {
		return ((OracleGateway<Region>) getGateway()).getAllBy(Region.class, c);
	}

	private Collection<City> getCities(Region r) throws SQLException {
		return ((OracleGateway<City>) getGateway()).getAllBy(City.class, r);
	}

	private Collection<University> getUniversities(City c) throws SQLException {
		return ((OracleGateway<University>) getGateway()).getAllBy(University.class, c);
	}

	private Gateway getGateway() {
		logger.info("Getting gateway");
		ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/beans.xml");
		return (Gateway) context.getBean("oracleGateway");
	}
}
