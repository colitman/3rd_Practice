package action;

import java.util.*;

public class ActionFactory {
	
	private static ActionFactory instance = new ActionFactory();	
	private static Map<String, Class<? implements Action>> actions = getActions();

	private ActionFactory() {}
	
	public static ActionFactory getInstance() {
		return instance;
	}
	
	public Action build(String actionName) throws WrongCommandException {
		if (!actions.keySet().contains(actionName)) {
			throw new WrongCommandException();
		}
		return actions.get(actionName).newInstance();
	}

	private Map<String, Class<? implements Action>> getActions() {
		Map<String, Class<? implements Action>> map = new HashMap<String, Class<? implements Action>>();
		
		map.put("homepage", action.handlers.homepage.GoHomePageAction.class);
		
		map.put("addCountry", action.handlers.country.AddAction.class);
		map.put("modifyCountry", action.handlers.country.ModifyAction.class);
		map.put("removeCountry", action.handlers.country.RemoveAction.class);
		map.put("updateCountry", action.handlers.country.UpdateAction.class);
		map.put("showAllCountry", action.handlers.country.ShowAllAction.class);
		map.put("showOneCountry", action.handlers.country.ShowOneAction.class);

		map.put("addRegion", action.handlers.region.AddAction.class);
		map.put("modifyRegion", action.handlers.region.ModifyAction.class);
		map.put("removeRegion", action.handlers.region.RemoveAction.class);
		map.put("updateRegion", action.handlers.region.UpdateAction.class);
		map.put("showAllRegion", action.handlers.region.ShowAllAction.class);
		map.put("showOneRegion", action.handlers.region.ShowOneAction.class);
		map.put("showAllRegionInCountry". action.handlers.region.ShowAllInCountryAction.class);

		map.put("addCity", action.handlers.city.AddAction.class);
		map.put("modifyCity", action.handlers.city.ModifyAction.class);
		map.put("removeCity", action.handlers.city.RemoveAction.class);
		map.put("updateCity", action.handlers.city.UpdateAction.class);
		map.put("showAllCity", action.handlers.city.ShowAllAction.class);
		map.put("showOneCity", action.handlers.city.ShowOneAction.class);
		map.put("showAllCityInRegion". action.handlers.region.ShowAllInRegionAction.class);

		map.put("addUniversity", action.handlers.university.AddAction.class);
		map.put("modifyUniversity", action.handlers.university.ModifyAction.class);
		map.put("removeUniversity", action.handlers.university.RemoveAction.class);
		map.put("updateUniversity", action.handlers.university.UpdateAction.class);
		map.put("showAllUniversity", action.handlers.university.ShowAllAction.class);
		map.put("showOneUniversity", action.handlers.university.ShowOneAction.class);
		map.put("showAllUniversityInCity". action.handlers.region.ShowAllInCityAction.class);

		return map;
	}
}