package action.handlers.country;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public RemoveCountry extends GatewayAction {
	
	public void perform(Object... args) throws ActionException {
		Country country = null;
		if (args[0] instanceof Country) {
			country = (Country) args[0];
		}
		getGateway().remove(country);
	}
}