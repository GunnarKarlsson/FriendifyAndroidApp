package com.squidzoo.VOs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Bindable]
	public class PersonVO extends EventDispatcher
	{
		public var id:String;
		public var name:String;
		public var category:String;
		
		public function PersonVO(id:String=null,name:String=null,category:String=null)
		{
			this.id = id;
			this.name = name;
			this.category = category;
		}
	}
}