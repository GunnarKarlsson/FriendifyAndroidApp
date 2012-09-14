package helpers
{
	import flash.events.EventDispatcher;
	
	import utils.FacebookTimeParser;
	import utils.RelativeDate;
	
	public class FacebookTime extends EventDispatcher
	{
		public static function getTime(time:String):String
		{
			var date:Date = FacebookTimeParser.parseDate(time);
			return RelativeDate.getRelativeDateFromNow(date,false);	
		}
	}
}