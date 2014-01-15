package action.handlers.country;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;

public class RemoveCountry extends GatewayAction {
	
	public void perform(Object... args) throws ActionException, SQLException {
		Country country = null;
		if (args[0] instanceof Country) {
			country = (Country) args[0];
		}
		getGateway().remove(country);
	}
}