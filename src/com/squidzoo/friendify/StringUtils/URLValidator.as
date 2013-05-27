package com.squidzoo.friendify.StringUtils {

		/**
		*	Copyright 2009 Martin Jacobsen.
		*
		*	@langversion ActionScript 3.0
		*	@playerversion Flash 10.0
		*
		*	@author Martin Jacobsen
		*	@since  2009-02-02
		*	@version 2.1
		*	@description :  Utility class for finding, validating and transforming URLs.
		*	
		*	Several URLParsers exist, but those I found were all too generic,
		*	mainly by being too restrictive (only accepting URLs with 'http' and .com | .org.| .net)
		*	or too lax (accepting .egg, .bacon and so forth). Hence this class.
		*	
		*	The URLParsing logic here is a unholy matrimoby of RegExp and String utilities.
		*	The ActionScript implementation of RegExp leaves something to be desired, and I decided
		*	to store the TLDs in a Vector partly because I've been told that running through a Vector
		*	is more effective than using RegExp when you're looking for exact matches and partly 
		*	because I just couldn't get the RegExp to work when it reached a certain length...
		*	Might just be my incompetence.
		*	
		*	The usage is pretty self-explanatory, but to sum it up;
		*	
		*	var validator : URLValidator = new URLValidator();
		*		validator.validate("http://google.com") // returns true;
		*		validator.validate("google.com") // returns true unless protocolOptional is set to false;
		*		
		*		var a:Array = validator.find(longStringWithScatteredURLs) // returns an Array of objects
		*			a[0].url // the URL.
		*			a[0].startIndex // the startIndex of the URL in the text
		*			a[0].endIndex // you get it...
		*	
		*		validator.tag(longStringWithScatteredURLs) // returns the original string
		*														// with all URLs neatly <a href'ed
		*														// optionally add tags and substitute text.
		*	
		*	
		*	@license: Do what thou wilt shall be the whole of the law. (But, hey: Credit is always welcome.)
		*	
		*	History: 
		*	
		*	2009-02-02: Initial version.
		*	
		*	2009-05-09: Bugfixes. New package signature.
		*	
		*	2009-08-05: Fixed bug handling multiple identical domains. Thanks Alex. (http://alexrindo.com/)
		*	
		*	
		*/
	

	public class URLValidator  {

		private var urlStructure 	: RegExp;
		private var domainList		: Vector.<String>;
		private var legal 			: Vector.<String>;
		
		public var trimHotChars		 : Boolean = true;
		public var protocolOptional : Boolean = true;
		
	
	public function URLValidator () {	
		createRules();
	}
	
	
	public function validate(stringToValidate:String) : Boolean {
		var isURL : Boolean = false;
			stringToValidate.toLowerCase();
		if(domainsValid(stringToValidate)) {
			if (urlStructure.exec(stringToValidate) != null &&
			stringToValidate.length == urlStructure.exec(stringToValidate)[0].length			)
			{	
					isURL = true;
			}
		}
		return isURL;
	}
	
	
	public function findValid(stringToValidate:String) : Boolean {
		var hasURL : Boolean = false;
			stringToValidate.toLowerCase();
		if(domainsValid(stringToValidate)) {
			if (urlStructure.exec(stringToValidate) != null){
				hasURL = true;
			}
		}
		return hasURL;
	}
		
		
	public function find(stringToSearch:String) : Array {
		var subToSearch : String = stringToSearch;
		var urlArray : Array = [];
		var searchPos : uint = 0;
			while(subToSearch.length > 3){
				if (urlStructure.exec(subToSearch) != null){
					var theURL : String = urlStructure.exec(subToSearch)[0];
					if(validate(theURL)){
						if(trimHotChars) theURL = trim(theURL);
						var o:Object = new Object;
							
								o.url = theURL;
								if (urlArray.length > 0)
								{o.startIndex = stringToSearch.indexOf(theURL, urlArray[urlArray.length - 1].endIndex + 1);
								} else { o.startIndex = stringToSearch.indexOf(theURL) }
								o.endIndex = o.startIndex + theURL.length;
								urlArray.push(o);
					}
					var n : uint = subToSearch.indexOf(theURL) + theURL.length;
					subToSearch = subToSearch.substring(n);
				} else {
					subToSearch = "";
				}
			}
			
			
		return urlArray;
	}
	
	private function trim(s:String) : String {
		for (var i:int = s.length; i > 0; i++){
			if(s.substr(s.length-1).match(/[\.\)?!\"",]/) != null){
				s = s.slice(0,s.length-1);
			} else {
				break;
			}
		}
		return s
	}

	public function tag( stringToSearch : String, 
								startTags : String = "", 
								endTags : String = "", 
								linkText : String = null) : String {
			
												
		var urls:Array = find(stringToSearch);
		var urlCounter:int = 0
		var stringToSearchSub:String = ""
		var outputString:String = ""
		
		var startIndex:int
		var endIndex:int;
		
			for each (var urlObj:Object in urls) {
				urlCounter++
				
				var theURL		: String;
				var originalURL: String;
					theURL = originalURL = urlObj.url;

				var link 		: String	 = "";
				var start 		: String = startTags + "<a href='"; 
				var end 		: String = "</a>" + endTags;
			
				//Hack to avoid "this....is" or Elton has.....been" etc strings treated as urls
				var patternToAvoid:RegExp = /\.\.+/;
				
					if(theURL.search(/((http|https|ftp):\/\/)/) < 0){
						if(theURL.search(patternToAvoid)<0){
						theURL = "http://" + theURL;
						}
					}
					
					if (linkText) link = linkText;
					else link = originalURL;
					
					if(theURL.search(patternToAvoid)<0){
						theURL = start + theURL + "'>" + link + end;
					}//end hack
					
					if(urls.length > 1){
						if (urlCounter == 1){
							startIndex = 0
							endIndex = urls[1].startIndex
						} 
						else if (urlCounter < urls.length) {
							startIndex = urls[urlCounter-1].startIndex
							endIndex = urls[urlCounter].startIndex
						} 
						else if (urlCounter == urls.length) {
							startIndex = urls[urlCounter-1].startIndex
							endIndex = -1
						}
						if(endIndex != -1){
							stringToSearchSub = stringToSearch.substring(startIndex, endIndex)
						} else { 
							stringToSearchSub = stringToSearch.substring(startIndex)	
						}
					} else {
						stringToSearchSub = stringToSearch
					}
					
					stringToSearchSub = stringToSearchSub.replace(originalURL, theURL);
					outputString += stringToSearchSub
				}
			
		return outputString;
	}

		
	private function domainsValid(hasDomainString:String) : Boolean {
		var hasDomain : Boolean = false;
		for each(var item:String in domainList){
			var tld : RegExp = new RegExp("(\\"+item+")");
			if (hasDomainString.search(tld) >-1){
				var nextChar : String;
				nextChar = hasDomainString.substr(hasDomainString.search(tld) + item.length, 1);
					hasDomain = true;
				}
			}
		
		function isLegal(q:String) : Boolean {
			var isLegit : Boolean = false;			
			for each (var legalChar:String in legal){
			if(q == legalChar){
				isLegit = true;
				break;
				}
			}
			return isLegit;
		}
		return hasDomain;
	}	
	

	public function createRules() : void {
						
		if(protocolOptional)
		urlStructure = /(((http|https|ftp):\/\/)?([-a-z0-9]*\.+)?[-a-zA-Z0-9]*\.[-a-zA-Z]+)([\/&\?=\.;%\+\$@~][\S]*)?/
		else 
		urlStructure = /(((http|https|ftp):\/\/)([-a-z0-9]*\.+)?[a-zA-Z0-9]*\.[a-zA-Z]+)([\/&\?=\.;%\+\$@~][\S]*)?/

		domainList = new Vector.<String>();
		domainList.push (".ac",".ad",".ae",".aero",".af",".ag",".ai",".al",".am",".an",".ao",".aq",".ar",".arpa",".as",".asia",".at",".au",".aw",".ax",".az",".ba",".bb",".bd",".be",".bf",".bg",".bh",".bi",".biz",".bj",".bm",".bn",".bo",".br",".bs",".bt",".bv",".bw",".by",".bz",".ca",".cat",".cc",".cd",".cf",".cg",".ch",".ci",".ck",".cl",".cm",".cn",".com",".coop",".cr",".cu",".cv",".cx",".cy",".cz",".de",".dj",".dk",".dm",".do",".dz",".ec",".edu",".ee",".eg",".er",".es",".et",".eu",".fi",".fj",".fk",".fm",".fo",".fr",".ga",".gb",".gd",".ge",".gf",".gg",".gh",".gi",".gl",".gm",".gn",".gov",".gp",".gq",".gr",".gs",".gt",".gu",".gw",".gy",".hk",".hm",".hn",".hr",".ht",".hu",".id",".ie",".il",".im",".in",".info",".int",".io",".iq",".ir",".is",".it",".je",".jm",".jo",".jobs",".jp",".ke",".kg",".kh",".ki",".km",".kn",".kp",".kr",".kw",".ky",".kz",".la",".lb",".lc",".li",".lk",".lr",".ls",".lt",".lu",".lv",".ly",".ma",".mc",".md",".me",".mg",".mh",".mil",".mk",".ml",".mm",".mn",".mo",".mobi",".mp",".mq",".mr",".ms",".mt",".mu",".museum",".mv",".mw",".mx",".my",".mz",".na",".name",".nc",".net",".nf",".ng",".ni",".nl",".no",".np",".nr",".nu",".nz",".om",".org",".pa",".pe",".pf",".pg",".ph",".pk",".pl",".pm",".pn",".pr",".pro",".ps",".pt",".pw",".py",".qa",".re",".ro",".rs",".ru",".rw",".sa",".sb",".sc",".sd",".se",".sg",".sh",".si",".sj",".sk",".sl",".sm",".sn",".so",".sr",".st",".su",".sv",".sy",".sz",".tc",".td",".tel",".tf",".tg",".th",".tj",".tk",".tl",".tm",".tn",".to",".tp",".tr",".travel",".tt",".tv",".tw",".tz",".ua",".ug",".uk",".us",".uy",".uz",".va",".vc",".ve",".vg",".vi",".vn",".vu",".wf",".ws",".ye",".yt",".yu",".za",".zm",".zw");
		
		domainList.sort(strLenSort);
		function strLenSort(x:String,y:String) : Number {
			if (x.length > y.length){
				return -1;
			} else {
				return 1;
			}
		}

	legal = new Vector.<String>();
	legal.push(" ","/","~","*","?",".",",",";",":","-","%","=","_","$","&","'","@","!","+","");

	} 		
	}	

}