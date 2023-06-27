public class GlyffixPOJO {

	public Boolean success;
	public String word;
	public Integer rowcount;
	public List<Data> data;
	public String errormessage;

	public class Data {
		public Integer id;
		public String imageurl;
	}


	public static GlyffixPOJO parse(String json) {
		return (GlyffixPOJO) System.JSON.deserialize(json, GlyffixPOJO.class);
	}
}