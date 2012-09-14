package services
{
	import com.facebook.graph.FacebookMobile;
	import com.hurlant.crypto.hash.MD5;
	
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	import org.igniterealtime.xiff.auth.SASLAuth;
	import org.igniterealtime.xiff.core.XMPPConnection;
	
	import services.FBService;
	
	public class FacebookSaslAuth extends SASLAuth
	{
		public static const MECHANISM:String = "X-FACEBOOK-PLATFORM";
		
		public static const NS:String = "urn:ietf:params:xml:ns:xmpp-sasl";
		
		public static var apiKey:String = "185652858176212";
		
		public static var sessionKey:String;
		
		// hardcode for now, can get it dynamically or something later
		public static var fbApiSecret:String;
		
		//GK's addition
		public var service:FBService = new FBService();
		
		public function FacebookSaslAuth(connection:XMPPConnection)
		{ 
			
			req.setNamespace( FacebookSaslAuth.NS);
			req.@mechanism = FacebookSaslAuth.MECHANISM;
			
			stage = 0;
		}
		
		/**
		 * <challenge xmlns="urn:ietf:params:xml:ns:xmpp-sasl">
		 * dmVyc2lvbj0xJm1ldGhvZD1hdXRoLnhtcHBfbG9naW4mbm9uY2U9NDM0NkI5QkZDNUExNjBENDZBRjI1NzMyQUNGQzdDQzM=
		 * </challenge>
		 */
		public override function handleChallenge(stage:int, challenge:XML):XML
		{
			var base64Challenge:String = challenge.text()[0].toString();
			var decoder:Base64Decoder = new Base64Decoder();
			decoder.decode(base64Challenge);
			var byteArray:ByteArray = decoder.flush();
			var decodedString:String = byteArray.toString();
			
			trace("decodedString: "+decodedString);
			
			var urlVars:URLVariables = new URLVariables(decodedString);
			
			var accessToken:String = FacebookMobile.getSession().accessToken;
			
			var responseUrlVars:URLVariables = new URLVariables();
			responseUrlVars.api_key = apiKey;
			responseUrlVars.access_token = accessToken;
			responseUrlVars.call_id = Math.floor(new Date().valueOf() / 1000);
			responseUrlVars.method = urlVars.method;
			responseUrlVars.nonce = urlVars.nonce;
			responseUrlVars.v = "1.0";
			
			var sig:String = 
				'method=' + responseUrlVars.method +
				'api_key=' + responseUrlVars.api_key +
				'access_token=' + responseUrlVars.access_token +
				'call_id=' + responseUrlVars.call_id +
				'v=' + responseUrlVars.v + 				
				'nonce=' + responseUrlVars.nonce;
			
			var sigBytes:ByteArray = new ByteArray();
			sigBytes.writeUTFBytes(sig);
			
			var md5:MD5 = new MD5();
			var hash:ByteArray = md5.hash(sigBytes);
			hash.position = 0;
			var hashStr:String = hash.toString();
			responseUrlVars.sig = "";
			
			for(var x:Number = 0; x < hashStr.length; x++) {
				responseUrlVars.sig += hashStr.charCodeAt(x).toString(16);
			}
			
			var responseString:String = responseUrlVars.toString();
			
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode(responseString);
			var responseBase64:String = encoder.toString();
			
			var responseXML:XML = 
				<response xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>
				{responseBase64}
			</response>;
			
			trace("response ready to be returned");
			
			return responseXML;
		}
		
		public override function handleResponse(stage:int, response:XML):Object
		{
			var success:Boolean = response.localName() == "success";
			return {
				authComplete: true,
				authSuccess: success,
				authStage: stage++
			};
		}
	}
}