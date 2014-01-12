package hibernate.logic;

public class Country {

	private int id;
	private String name;
	private String language;
	private int population;
	private int timezone;
	private Set<Region> regions;

	public Country {

	}
	
	public void setID(int id) {
		this.id = id;
	} 

	public int getID() {
		return id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	public Srting getLanguage() {
		return language;
	}

	public void setPopulation(int population) {
		this.population = population;
	}

	public int getPopulation() {
		return population;
	}

	public void setTimezone(int timezone) {
		this.timezone = timezone;
	}

	public int getTimezone() {
		return timezone;
	}

	public void setRegions(Set<Region> regions) {
		this.regions = regions.clone();
	}
	
	public Set<Region> getRegions() {
		return regions;
	}
}