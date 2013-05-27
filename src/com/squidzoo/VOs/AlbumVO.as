package com.squidzoo.VOs
{
	import com.facebook.graph.FacebookMobile;
	
	import flash.events.EventDispatcher;

	[Bindable]
	public class AlbumVO extends EventDispatcher
	{
		public var name:String;
		public var id:String;
		public var photos:Array;
		public var link:String;
		public var coverPhoto:String;
		public var count:uint;
		
		public function AlbumVO()
		{
		}
		
	}
}