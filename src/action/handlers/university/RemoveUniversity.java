package action.handlers.university;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public RemoveUniversity extends GatewayAction {
	
	public void perform(Object... args) throws ActionException {
		University university = null;
		if (args[0] instanceof University) {
			university = (University) args[0];
		}
		getGateway().remove(university);
	}
}