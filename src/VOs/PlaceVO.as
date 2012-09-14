package VOs
{
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class PlaceVO extends EventDispatcher
	{
		public var category:String;
		public var id:String;
		public var location:Object;
		public var latitude:Number;
		public var longitude:Number;
		public var name:String;
		public var city:String;
		
	}
}