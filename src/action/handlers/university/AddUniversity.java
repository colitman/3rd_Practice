package action.handlers.university;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;

public class AddUniversity extends GatewayAction {
	
	public void perform(Object... args) throws ActionException, SQLException {
		University university = null;
		if (args[0] instanceof University) {
			university = (University) args[0];
		}
		getGateway().add(university);
	}
}