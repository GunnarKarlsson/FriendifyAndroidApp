package com.squidzoo.VOs
{
	import com.facebook.graph.Facebook;
	import com.facebook.graph.FacebookMobile;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Bindable]
	public class RosterVO extends EventDispatcher
	{
		public var name:String;
		private var id:String;
		
		public function RosterVO(id:String)
		{
			
		}
		
		
	}
}