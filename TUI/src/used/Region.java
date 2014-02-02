package used;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Region implements Entity {
	private String name;
	private List<City> cities = new ArrayList<City>();
	
	public Region(String name) {
		setName(name);
	}
	
	public void addCity(City city) {
		cities.add(city);
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public List<City> getCities() {
		return cities;
	}

	public void setCities(List<City> cities) {
		this.cities = cities;
	}

	public Map<String, String> getParams() {
		return new HashMap<String, String>();
	}

	@Override
	public String toString() {
		return name;
	}
}
