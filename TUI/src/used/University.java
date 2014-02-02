package used;

import java.util.HashMap;
import java.util.Map;

public class University implements Entity {
	private String name;
	private Map<String, String> params = new HashMap<String, String>();
	
	public University(String name, int facs) {
		setName(name);
		setParam("Amount of faculties", String.valueOf(facs));
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getFacs() {
		return params.get("Amount of faculties");
	}
	
	public void setParam(String key, String value) {
		params.put(key, value);
	}
	
	public String getParam(String key) {
		return params.get(key);
	}
	
	public Map<String, String> getParams() {
		return params;
	}

	@Override
	public String toString() {
		return name;
	}
}
