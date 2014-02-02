package used;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class City implements Entity {
	public Map<String, String> getParams() {
		return new HashMap<String, String>();
	}

	private String name;
	private List<University> unis = new ArrayList<University>();
	
	public City(String name) {
		setName(name);
	}
	
	public void addUni(University uni) {
		unis.add(uni);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public List<University> getUnis() {
		return unis;
	}

	public void setUnis(List<University> unis) {
		this.unis = unis;
	}

	@Override
	public String toString() {
		return name;
	}
}
