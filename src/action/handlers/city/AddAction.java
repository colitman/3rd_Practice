package action.handlers.city;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public AddAction implements Action {
	
	public void perform(Object... args) throws ActionException {
		City city = null;
		if (args[0] instanceof City) {
			city = (City) args[0];
		}
		new OracleGateway<City>().add(city);
	}
}