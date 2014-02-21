package util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import action.ActionFactory

public class Utils {
	
	public static void perform(String action, HttpServletRequest request, HttpServletResponse response) {
		ActionFactory.getInstance().build(action).perform(request, response);
	}
}