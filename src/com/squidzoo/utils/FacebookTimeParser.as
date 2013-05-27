package com.squidzoo.utils
{
	/**
	 * parse date string from facebook
	 */
	public class FacebookTimeParser
	{
		
		/** 
		 * facebook date string format: "2010-11-07T10:00:00+0000"
		 * convert to "2010/11/07 10:00:00 GMT-0000", 
		 * then use flex Date.parse() to parse it.  
		 * 
		 */
		public static function parseDate(dateStr:String):Date {
			var date:Date = null;
			if (dateStr) {
				dateStr = dateStr.replace(/\-/g, "/");
				dateStr = dateStr.replace("T", " ");
				dateStr = dateStr.replace("+0000", " GMT-0000");
				
				date = new Date(Date.parse(dateStr));
			}
			
			return date;
		}
		
		public static function parseUTCDate( str : String ) : Date {
			
				var matches : Array = str.match(/(\d*)-(\d*)-(\d*)T(\d*):(\d*)/);
			
				trace("s0 "+matches);
				
				var d : Date = new Date();
				
				d.setUTCFullYear(int(matches[1]), int(matches[2]) - 1, int(matches[3]));
				d.setUTCHours(int(matches[4]), int(matches[5]), 0);
				return d;
		}
		
		public static function parseSlashedDate( str : String ) : Date {
			trace("s1 "+str);
			var matches : Array = str.match(/(\d*)\/(\d*)\/?(\d*)?/);
			trace("s2 "+matches);
			trace(int(matches[1]));//month
			trace(int(matches[2]));//day
			trace(int(matches[3]));//year

				var d : Date = new Date();//int(matches[3]), int(matches[1])-1, int(matches[2]));
				if(matches[1])
				{
					d.month = int(matches[1]);
				}
				if(matches[2])
				{
					d.date = int(matches[2]);					
				}
				if(matches[3])
				{
					d.fullYear = int(matches[3]);
				}
				
			return d;
		}
		
		
	}
}