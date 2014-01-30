package action.handlers.city;

import action.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import org.springframework.beans.factory.*;
import hibernate.dao.*;
import hibernate.logic.*;

public class ShowOneCity implements HttpAction {
	
	public void perform(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		try {
			ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/beans.xml");
			Gateway<City> gateway = (Gateway) context.getBean("oracleGateway");
			int id = Integer.valueOf(request.getParameter("id"));
			City city = gateway.get(id);
			request.getSession().setAttribute("city", city);
			response.sendRedirect("/WebPrototype/city/showOne.jsp?id=" + id);
		}
		catch (Exception e) {
			try {
				response.sendRedirect("/WebPrototype/error.jsp");
			}
			catch (Exception ex) {
				
			}
		}
	}
}