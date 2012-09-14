package VOs
{
	import flash.events.EventDispatcher;
	
	public class EventVO extends EventDispatcher
	{
		public var id:String;
		public var owner:Object = new Object();
		public var name:String;
		public var startTime:String;
		public var endTime:String;
		public var privacy:String;
		public var rsvpStatus:String; 
		public var type:String;
		
	}
}