package action.handlers.country;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public AddCountryAction implements Action {
	
	public void perform(Object... args) throws ActionException {
		Country country = null;
		if (args[0] instanceof Country) {
			country = (Country) args[0];
		}
		new OracleGateway<Country>().add(country);
	}
}