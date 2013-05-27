package com.squidzoo.friendify.helpers
{
	import flash.events.EventDispatcher;
	
	import com.squidzoo.utils.FacebookTimeParser;
	import com.squidzoo.utils.RelativeDate;
	
	public class FacebookTime extends EventDispatcher
	{
		public static function getTime(time:String):String
		{
			var date:Date = FacebookTimeParser.parseDate(time);
			return RelativeDate.getRelativeDateFromNow(date,false);	
		}
	}
}