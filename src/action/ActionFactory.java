package action;

import java.util.*;

public class ActionFactory {
	
	private static ActionFactory instance = new ActionFactory();	
	private static Map<String, Class<? extends Action>> actions = getActions();

	private ActionFactory() {}
	
	public static ActionFactory getInstance() {
		return instance;
	}
	
	public Action build(String actionName) throws WrongCommandException, InstantiationException, IllegalAccessException {
		if (!actions.keySet().contains(actionName)) {
			throw new WrongCommandException();
		}
		return actions.get(actionName).newInstance();
	}

	private static Map<String, Class<? extends Action>> getActions() {
		Map<String, Class<? extends Action>> map = new HashMap<String, Class<? extends Action>>();
		
		map.put("homepage", action.handlers.homepage.GoHomePageAction.class);
		
		map.put("addCountry", action.handlers.country.AddCountry.class);
		map.put("modifyCountry", action.handlers.country.ModifyCountry.class);
		map.put("removeCountry", action.handlers.country.RemoveCountry.class);
		map.put("showAllCountry", action.handlers.country.ShowAllCountry.class);
		map.put("showOneCountry", action.handlers.country.ShowOneCountry.class);

		map.put("addRegion", action.handlers.region.AddRegion.class);
		map.put("modifyRegion", action.handlers.region.ModifyRegion.class);
		map.put("removeRegion", action.handlers.region.RemoveRegion.class);
		map.put("showAllRegion", action.handlers.region.ShowAllRegion.class);
		map.put("showOneRegion", action.handlers.region.ShowOneRegion.class);
		map.put("showAllRegionInCountry", action.handlers.region.ShowAllRegionInCountry.class);

		map.put("addCity", action.handlers.city.AddCity.class);
		map.put("modifyCity", action.handlers.city.ModifyCity.class);
		map.put("removeCity", action.handlers.city.RemoveCity.class);
		map.put("showAllCity", action.handlers.city.ShowAllCity.class);
		map.put("showOneCity", action.handlers.city.ShowOneCity.class);
		map.put("showAllCityInRegion", action.handlers.city.ShowAllCityInRegion.class);

		map.put("addUniversity", action.handlers.university.AddUniversity.class);
		map.put("modifyUniversity", action.handlers.university.ModifyUniversity.class);
		map.put("removeUniversity", action.handlers.university.RemoveUniversity.class);
		map.put("showAllUniversity", action.handlers.university.ShowAllUniversity.class);
		map.put("showOneUniversity", action.handlers.university.ShowOneUniversity.class);
		map.put("showAllUniversityInCity", action.handlers.university.ShowAllUniversityInCity.class);

		return map;
	}
}