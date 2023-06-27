public class GlyffixService {
	@future (callout=true)
	public static void getImageUrl(ID recordId){
		System.debug('OLOLO');
		Product__c record = [SELECT ID, Name, Image__c FROM Product__c WHERE Id = :recordId];
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		List<Object> queryParams = new List<Object>();
		queryParams.add(EncodingUtil.urlEncode(record.Name, 'UTF-8'));
		String endpoint = String.format('http://www.glyffix.com/api/Image?word={0}', queryParams);
		request.setEndpoint(endpoint);
		request.setMethod('GET');
		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		HttpResponse response = http.send(request);
		// Parse the JSON response
		if(response.getStatusCode() != 200) {
			System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
		} else {
			GlyffixPOJO glyffixPOJO = GlyffixPOJO.parse(response.getBody());
			if (glyffixPOJO.data.size()>0){
				record.Image__c = glyffixPOJO.data.get(0).imageurl;
			}
		}

		update record;
	}
}