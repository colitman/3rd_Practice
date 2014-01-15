package action.handlers.region;

import action.*;
import hibernate.dao.*;
import hibernate.logic.*;
import java.sql.*;

public class AddRegion extends GatewayAction {
	
	public void perform(Object... args) throws ActionException, SQLException {
		Region region = null;
		if (args[0] instanceof Region) {
			region = (Region) args[0];
		}
		getGateway().add(region);
	}
}