package com.squidzoo.VOs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class GroupVO extends EventDispatcher
	{
		public var id:String;
		public var icon:String;//url
		public var owner:Object = new Object();//id and name
		public var name:String;
		public var description:String;
		public var link:String;//url for groups website
		public var privacy:String//OPEN,CLOSED or SECRET
		public var updatedTime:String
		
		public function GroupVO()
		{
			
		}
	}
}