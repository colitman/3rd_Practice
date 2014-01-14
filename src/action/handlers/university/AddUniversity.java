package action.handlers.university;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public AddUniversity extends GatewayAction {
	
	public void perform(Object... args) throws ActionException {
		University university = null;
		if (args[0] instanceof university) {
			university = (University) args[0];
		}
		getGateway().add(university);
	}
}