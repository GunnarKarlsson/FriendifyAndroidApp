package com.squidzoo.VOs
{
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class CommentVO extends EventDispatcher
	{
		public var id:String;
		public var from:Object = new Object();
		public var message:String;
		public var createdTime:String;
		public var likes:int;
		public var userLikes:Boolean;
		public var type:String;
	}
}