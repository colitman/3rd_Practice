package action;

import java.util.*;
import org.apache.log4j.*;

public class ActionFactory {
	
	private static final Logger logger = Logger.getLogger(ActionFactory.class);	
	private static ActionFactory instance = new ActionFactory();	
	private static Map<String, Class<? extends HttpAction>> actions = getActions();

	private ActionFactory() {}
	
	public static ActionFactory getInstance() {
		logger.info("Getting ActionFactory");
		return instance;
	}
	
	public HttpAction build(String actionName) throws WrongCommandException, InstantiationException, IllegalAccessException {
		logger.info("Building HttpAction");
		if (!actions.keySet().contains(actionName)) {
			logger.error("Error in ActionFactory: wrong command");
			throw new WrongCommandException();
		}
		return actions.get(actionName).newInstance();
	}

	private static Map<String, Class<? extends HttpAction>> getActions() {
		logger.info("Initializing ActionFactory");

		Map<String, Class<? extends HttpAction>> map = new HashMap<String, Class<? extends HttpAction>>();
		
		map.put("addCountry", action.handlers.country.AddCountry.class);
		map.put("modifyCountry", action.handlers.country.ModifyCountry.class);
		map.put("removeCountry", action.handlers.country.RemoveCountry.class);
		map.put("showAllCountry", action.handlers.country.ShowAllCountry.class);

		map.put("addRegion", action.handlers.region.AddRegion.class);
		map.put("modifyRegion", action.handlers.region.ModifyRegion.class);
		map.put("removeRegion", action.handlers.region.RemoveRegion.class);
		map.put("showAllRegionInCountry", action.handlers.region.ShowAllRegionInCountry.class);

		map.put("addCity", action.handlers.city.AddCity.class);
		map.put("modifyCity", action.handlers.city.ModifyCity.class);
		map.put("removeCity", action.handlers.city.RemoveCity.class);
		map.put("showAllCityInRegion", action.handlers.city.ShowAllCityInRegion.class);

		map.put("addUniversity", action.handlers.university.AddUniversity.class);
		map.put("modifyUniversity", action.handlers.university.ModifyUniversity.class);
		map.put("removeUniversity", action.handlers.university.RemoveUniversity.class);
		map.put("showOneUniversity", action.handlers.university.ShowOneUniversity.class);
		map.put("showAllUniversityInCity", action.handlers.university.ShowAllUniversityInCity.class);

		return map;
	}
}