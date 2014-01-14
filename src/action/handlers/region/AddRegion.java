package action.handlers.region;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;

public AddRegion extends GatewayAction {
	
	public void perform(Object... args) throws ActionException {
		Region region = null;
		if (args[0] instanceof Region) {
			region = (Region) args[0];
		}
		getGateway().add(region);
	}
}