package action.handlers.region;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.util.Collection;

public class ShowAllRegion implements HttpAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/beans.xml");
			Gateway<Region> gateway = (Gateway<Region>) context.getBean("oracleGateway");
			Collection<Region> regions = gateway.getAll(Region.class);
			request.getSession().setAttribute("regions", regions);
			response.sendRedirect("/WebPrototype/region/showAll.jsp");
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