package action.handlers.city;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;

public class AddCity extends GatewayAction {
	
	public void perform(Object... args) throws ActionException, SQLException {
		City city = null;
		if (args[0] instanceof City) {
			city = (City) args[0];
		}
		getGateway().add(city);
	}
}