package com.squidzoo.VOs
{
	import com.facebook.graph.FacebookMobile;
	
	import flash.events.EventDispatcher;
	
	import spark.components.Image;
	
	[Bindable]
	public class FriendVO extends EventDispatcher
	{
		public var name:String;
		public var id:String;
		public var type:String;
		
		public var bio:String;
		public var birthday:String;
		public var relationShipStatus:String;
		public var homeTown:String;
		public var homeTownId:String;
		public var searchType:String = "";
	
		public function FriendVO(name:String,id:String):void{
			this.id = id;
			this.name = name;
			this.type = "friend";
		}
	}
}