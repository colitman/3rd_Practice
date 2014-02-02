package used;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Country implements Entity {
	private String name;
	private String lang;
	private String capital;
	private Map<String, String> params = new HashMap<String, String>();
	private List<Region> regs = new ArrayList<Region>();
	
	public Country(String name, String capital, String lang) {
		setName(name);
		setCapital(capital);
		setParam("Capital", capital);
		setLang(lang);
		setParam("Language", lang);
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

	public void addRegion(Region reg) {
		regs.add(reg);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	public String getCapital() {
		return capital;
	}

	public void setCapital(String capital) {
		this.capital = capital;
	}
	
	public List<Region> getRegs() {
		return regs;
	}

	public void setRegs(List<Region> regs) {
		this.regs = regs;
	}

	@Override
	public String toString() {
		return name;
	}
}
